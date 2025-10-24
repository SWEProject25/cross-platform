//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/profile_response_dto.dart';
import 'package:openapi/src/model/pagination_metadata.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_profile_response_dto.g.dart';

/// SearchProfileResponseDto
///
/// Properties:
/// * [status] - Response status
/// * [message] - Response message
/// * [data] - Array of matching profiles
/// * [metadata] - Pagination metadata
@BuiltValue()
abstract class SearchProfileResponseDto implements Built<SearchProfileResponseDto, SearchProfileResponseDtoBuilder> {
  /// Response status
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Array of matching profiles
  @BuiltValueField(wireName: r'data')
  BuiltList<ProfileResponseDto> get data;

  /// Pagination metadata
  @BuiltValueField(wireName: r'metadata')
  PaginationMetadata get metadata;

  SearchProfileResponseDto._();

  factory SearchProfileResponseDto([void updates(SearchProfileResponseDtoBuilder b)]) = _$SearchProfileResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchProfileResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchProfileResponseDto> get serializer => _$SearchProfileResponseDtoSerializer();
}

class _$SearchProfileResponseDtoSerializer implements PrimitiveSerializer<SearchProfileResponseDto> {
  @override
  final Iterable<Type> types = const [SearchProfileResponseDto, _$SearchProfileResponseDto];

  @override
  final String wireName = r'SearchProfileResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchProfileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ProfileResponseDto)]),
    );
    yield r'metadata';
    yield serializers.serialize(
      object.metadata,
      specifiedType: const FullType(PaginationMetadata),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchProfileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchProfileResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProfileResponseDto)]),
          ) as BuiltList<ProfileResponseDto>;
          result.data.replace(valueDes);
          break;
        case r'metadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaginationMetadata),
          ) as PaginationMetadata;
          result.metadata.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchProfileResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchProfileResponseDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

