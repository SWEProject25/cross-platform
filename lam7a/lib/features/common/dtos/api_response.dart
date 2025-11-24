import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required String status,
    required T data,
    required Metadata metadata,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}

class Metadata {
  final int totalItems;
  final int page;
  final int limit;
  final int totalPages;

  Metadata({
    required this.totalItems,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    totalItems: json['totalItems'],
    page: json['page'],
    limit: json['limit'],
    totalPages: json['totalPages'],
  );

  Map<String, dynamic> toJson() => {
    'totalItems': totalItems,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
  };
}
