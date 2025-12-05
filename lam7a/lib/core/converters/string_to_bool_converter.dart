import 'package:freezed_annotation/freezed_annotation.dart';

class StringToBoolConverter implements JsonConverter<bool?, Object?> {
  const StringToBoolConverter();

  @override
  bool? fromJson(Object? json) {
    if (json is bool) return json;
    if (json is String) return json.toLowerCase() == 'true';
    return null;
  }

  @override
  Object? toJson(bool? value) => value;
}
