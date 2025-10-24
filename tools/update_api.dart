// tool/build.dart
import 'dart:convert';
import 'dart:io';

/// ================== CONFIG (edit as you like) ==================
const swaggerUrl = 'http://backend-code.duckdns.org/dev/swagger.json';
const downloadPath = 'swagger.json';
const fixedPath = 'swagger_fixed.json';
const outputDir = 'Lam7aApi';
/// ===============================================================

Future<void> main(List<String> args) async {
  _log('Starting cross-platform OpenAPI build…');

  try {
    // 1) Download OpenAPI JSON
    await _downloadSwagger(swaggerUrl, downloadPath);

    // 2) Fix operationIds (try external script, otherwise built-in Dart fix)
    await _dartFixOperationIds(downloadPath, fixedPath);

    // 3) Remove previous output directory (if exists)
    await _removeDirIfExists(outputDir);

    // 4) Ensure openapi-generator-cli exists (install if needed)
    await _ensureOpenApiGenerator();

    // 5) Generate Dart client
    await _runCmd(
      'openapi-generator-cli',
      ['generate', '-i', fixedPath, '-g', 'dart-dio', '-o', outputDir],
    );

    // 6) Cleanup generator extras
    await _removeDirIfExists('$outputDir/test');
    await _removeDirIfExists('$outputDir/doc');
    // await _removeFileIfExists(downloadPath);
    // await _removeFileIfExists(fixedPath);

    // 7) Flutter steps
    await _runCmd('flutter', ['pub', 'get'], workingDirectory: outputDir);

    await _runCmd(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: outputDir,
    );

    _log('');
    _log('✅ All steps completed successfully.');
    exitCode = 0;
  } catch (e, st) {
    _err('Build failed: $e');
    // print stack for debugging in CI
    stderr.writeln(st);
    exitCode = 1;
  }
}

/// Download OpenAPI JSON using Dart's HttpClient (no external curl dependency).
Future<void> _downloadSwagger(String url, String outPath) async {
  _log('↓ Downloading OpenAPI JSON from $url');
  final client = HttpClient();
  try {
    final req = await client.getUrl(Uri.parse(url));
    final res = await req.close();

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw 'HTTP ${res.statusCode} downloading $url';
    }
    final bytes = await res.fold<List<int>>([], (b, d) => b..addAll(d));
    await File(outPath).writeAsBytes(bytes);
    _log('✓ Saved to $outPath (${bytes.length} bytes)');
  } finally {
    client.close(force: true);
  }
}

/// Built-in Dart fixer for operationId:
/// - Traverses the OpenAPI JSON structure
/// - If it finds a string "operationId": "prefix_rest", it trims the prefix up to the first underscore
///   Example: "Api_getUser" -> "getUser"
/// - Ensures resulting operationIds remain non-empty
Future<void> _dartFixOperationIds(String input, String output) async {
  _log('🧽 Fixing operationId values (built-in).');
  final text = await File(input).readAsString();
  final dynamic jsonData = jsonDecode(text);

  // Collect all operations under paths to fix operationId
  if (jsonData is! Map<String, dynamic>) {
    throw 'Invalid JSON at $input (expected object).';
  }

  final seen = <String, int>{}; // to help uniqueness if needed
  void fixMap(Map<String, dynamic> m) {
    m.forEach((k, v) {
      if (k == 'operationId' && v is String) {
        final fixed = _stripPrefixBeforeFirstUnderscore(v);
        final unique = _ensureUnique(fixed, seen);
        m[k] = unique;
      } else if (v is Map<String, dynamic>) {
        fixMap(v);
      } else if (v is List) {
        for (final e in v) {
          if (e is Map<String, dynamic>) fixMap(e);
        }
      }
    });
  }

  fixMap(jsonData);
  final pretty = const JsonEncoder.withIndent('  ').convert(jsonData);
  await File(output).writeAsString(pretty);
  _log('✓ Wrote fixed spec to $output');
}

String _stripPrefixBeforeFirstUnderscore(String s) {
  final idx = s.indexOf('_');
  if (idx == -1 || idx == s.length - 1) return s; // no underscore or trailing underscore
  return s.substring(idx + 1);
}

String _ensureUnique(String opId, Map<String, int> seen) {
  final count = (seen[opId] ?? 0);
  if (count == 0) {
    seen[opId] = 1;
    return opId;
  }
  final newId = '$opId${count + 1}';
  seen[opId] = count + 1;
  return newId;
}

/// Ensure openapi-generator-cli exists; if not, install via npm.
Future<void> _ensureOpenApiGenerator() async {
  final found = await _commandExists('openapi-generator-cli');
  if (found) {
    _log('✓ openapi-generator-cli found.');
    return;
  }
  _log('… openapi-generator-cli not found, installing globally via npm.');
  if (!await _commandExists('npm')) {
    throw 'npm is required to install openapi-generator-cli but was not found on PATH.';
  }
  await _runCmd('npm', ['install', '-g', '@openapitools/openapi-generator-cli']);
  // Re-check
  if (!await _commandExists('openapi-generator-cli')) {
    throw 'openapi-generator-cli not found after installation.';
  }
  _log('✓ openapi-generator-cli installed.');
}

Future<bool> _commandExists(String command) async {
  final which = Platform.isWindows ? 'where' : 'which';
  final res = await Process.run(which, [command]);
  return res.exitCode == 0 && (res.stdout as String).toString().trim().isNotEmpty;
}

Future<void> _removeDirIfExists(String path) async {
  final dir = Directory(path);
  if (await dir.exists()) {
    _log('🗑 Removing existing $path …');
    await dir.delete(recursive: true);
  }
}

Future<void> _removeFileIfExists(String path) async {
  final f = File(path);
  if (await f.exists()) {
    await f.delete();
  }
}

Future<void> _runCmd(
  String cmd,
  List<String> args, {
  String? workingDirectory,
}) async {
  final pretty = '$cmd ${args.map((a) => a.contains(' ') ? '"$a"' : a).join(' ')}';
  _log('▶ $pretty${workingDirectory != null ? '  (cwd: $workingDirectory)' : ''}');
  final process = await Process.start(
    cmd,
    args,
    workingDirectory: workingDirectory,
    runInShell: true,
  );

  // Pipe live output
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);

  final exit = await process.exitCode;
  if (exit != 0) {
    throw '$cmd exited with code $exit';
  }
}

void _log(String msg) => stdout.writeln(msg);
void _err(String msg) => stderr.writeln('[ERROR] $msg');
