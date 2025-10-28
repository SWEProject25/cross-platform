// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_service_mock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for media upload service

@ProviderFor(mediaUploadService)
const mediaUploadServiceProvider = MediaUploadServiceProvider._();

/// Provider for media upload service

final class MediaUploadServiceProvider
    extends
        $FunctionalProvider<
          MediaUploadService,
          MediaUploadService,
          MediaUploadService
        >
    with $Provider<MediaUploadService> {
  /// Provider for media upload service
  const MediaUploadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaUploadServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaUploadServiceHash();

  @$internal
  @override
  $ProviderElement<MediaUploadService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MediaUploadService create(Ref ref) {
    return mediaUploadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaUploadService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaUploadService>(value),
    );
  }
}

String _$mediaUploadServiceHash() =>
    r'f3338672c12afef0dd1ebadbdefdeab995c947d4';
