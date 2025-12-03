import 'package:freezed_annotation/freezed_annotation.dart';

class StringToIntConverter implements JsonConverter<int?, Object?> {
  const StringToIntConverter();

  @override
  int? fromJson(Object? json) {
    if (json is int) return json;
    if (json is String) return int.tryParse(json) ?? 0;
    return null;
  }

  @override
  Object? toJson(int? value) => value;
}
