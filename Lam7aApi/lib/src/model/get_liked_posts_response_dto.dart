//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/get_liked_posts_response_dto_data_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_liked_posts_response_dto.g.dart';

/// GetLikedPostsResponseDto
///
/// Properties:
/// * [status] - Status of the response
/// * [message] - Response message
/// * [data] - Array of posts liked by the user
@BuiltValue()
abstract class GetLikedPostsResponseDto implements Built<GetLikedPostsResponseDto, GetLikedPostsResponseDtoBuilder> {
  /// Status of the response
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Array of posts liked by the user
  @BuiltValueField(wireName: r'data')
  BuiltList<GetLikedPostsResponseDtoDataInner> get data;

  GetLikedPostsResponseDto._();

  factory GetLikedPostsResponseDto([void updates(GetLikedPostsResponseDtoBuilder b)]) = _$GetLikedPostsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetLikedPostsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetLikedPostsResponseDto> get serializer => _$GetLikedPostsResponseDtoSerializer();
}

class _$GetLikedPostsResponseDtoSerializer implements PrimitiveSerializer<GetLikedPostsResponseDto> {
  @override
  final Iterable<Type> types = const [GetLikedPostsResponseDto, _$GetLikedPostsResponseDto];

  @override
  final String wireName = r'GetLikedPostsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetLikedPostsResponseDto object, {
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
      specifiedType: const FullType(BuiltList, [FullType(GetLikedPostsResponseDtoDataInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetLikedPostsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetLikedPostsResponseDtoBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(GetLikedPostsResponseDtoDataInner)]),
          ) as BuiltList<GetLikedPostsResponseDtoDataInner>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetLikedPostsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetLikedPostsResponseDtoBuilder();
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

