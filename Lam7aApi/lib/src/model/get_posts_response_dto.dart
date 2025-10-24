//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/post_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_posts_response_dto.g.dart';

/// GetPostsResponseDto
///
/// Properties:
/// * [status] - Status of the response
/// * [message] - Response message
/// * [data] - Array of posts
@BuiltValue()
abstract class GetPostsResponseDto implements Built<GetPostsResponseDto, GetPostsResponseDtoBuilder> {
  /// Status of the response
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Array of posts
  @BuiltValueField(wireName: r'data')
  BuiltList<PostResponseDto> get data;

  GetPostsResponseDto._();

  factory GetPostsResponseDto([void updates(GetPostsResponseDtoBuilder b)]) = _$GetPostsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetPostsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetPostsResponseDto> get serializer => _$GetPostsResponseDtoSerializer();
}

class _$GetPostsResponseDtoSerializer implements PrimitiveSerializer<GetPostsResponseDto> {
  @override
  final Iterable<Type> types = const [GetPostsResponseDto, _$GetPostsResponseDto];

  @override
  final String wireName = r'GetPostsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetPostsResponseDto object, {
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
      specifiedType: const FullType(BuiltList, [FullType(PostResponseDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetPostsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetPostsResponseDtoBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(PostResponseDto)]),
          ) as BuiltList<PostResponseDto>;
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
  GetPostsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetPostsResponseDtoBuilder();
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

