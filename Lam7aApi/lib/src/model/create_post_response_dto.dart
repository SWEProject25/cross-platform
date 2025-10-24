//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/post_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_post_response_dto.g.dart';

/// CreatePostResponseDto
///
/// Properties:
/// * [status] - Status of the response
/// * [message] - Response message
/// * [data] - The created post data
@BuiltValue()
abstract class CreatePostResponseDto implements Built<CreatePostResponseDto, CreatePostResponseDtoBuilder> {
  /// Status of the response
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// The created post data
  @BuiltValueField(wireName: r'data')
  PostResponseDto get data;

  CreatePostResponseDto._();

  factory CreatePostResponseDto([void updates(CreatePostResponseDtoBuilder b)]) = _$CreatePostResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatePostResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatePostResponseDto> get serializer => _$CreatePostResponseDtoSerializer();
}

class _$CreatePostResponseDtoSerializer implements PrimitiveSerializer<CreatePostResponseDto> {
  @override
  final Iterable<Type> types = const [CreatePostResponseDto, _$CreatePostResponseDto];

  @override
  final String wireName = r'CreatePostResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatePostResponseDto object, {
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
      specifiedType: const FullType(PostResponseDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatePostResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatePostResponseDtoBuilder result,
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
            specifiedType: const FullType(PostResponseDto),
          ) as PostResponseDto;
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
  CreatePostResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatePostResponseDtoBuilder();
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

