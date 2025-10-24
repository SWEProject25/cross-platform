//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_response_dto.g.dart';

/// PostResponseDto
///
/// Properties:
/// * [id] - The unique identifier of the post
/// * [userId] - The ID of the user who created the post
/// * [content] - The textual content of the post
/// * [type] - The type of post
/// * [parentId] - The ID of the parent post (if this is a reply or quote)
/// * [visibility] - The visibility level of the post
/// * [createdAt] - The date and time when the post was created
@BuiltValue()
abstract class PostResponseDto implements Built<PostResponseDto, PostResponseDtoBuilder> {
  /// The unique identifier of the post
  @BuiltValueField(wireName: r'id')
  num get id;

  /// The ID of the user who created the post
  @BuiltValueField(wireName: r'userId')
  num get userId;

  /// The textual content of the post
  @BuiltValueField(wireName: r'content')
  String get content;

  /// The type of post
  @BuiltValueField(wireName: r'type')
  PostResponseDtoTypeEnum get type;
  // enum typeEnum {  POST,  REPLY,  QUOTE,  };

  /// The ID of the parent post (if this is a reply or quote)
  @BuiltValueField(wireName: r'parentId')
  JsonObject? get parentId;

  /// The visibility level of the post
  @BuiltValueField(wireName: r'visibility')
  PostResponseDtoVisibilityEnum get visibility;
  // enum visibilityEnum {  EVERY_ONE,  FOLLOWERS,  MENTIONED,  };

  /// The date and time when the post was created
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PostResponseDto._();

  factory PostResponseDto([void updates(PostResponseDtoBuilder b)]) = _$PostResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PostResponseDto> get serializer => _$PostResponseDtoSerializer();
}

class _$PostResponseDtoSerializer implements PrimitiveSerializer<PostResponseDto> {
  @override
  final Iterable<Type> types = const [PostResponseDto, _$PostResponseDto];

  @override
  final String wireName = r'PostResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PostResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(num),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(num),
    );
    yield r'content';
    yield serializers.serialize(
      object.content,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PostResponseDtoTypeEnum),
    );
    yield r'parentId';
    yield object.parentId == null ? null : serializers.serialize(
      object.parentId,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(PostResponseDtoVisibilityEnum),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PostResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PostResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.id = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.userId = valueDes;
          break;
        case r'content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.content = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PostResponseDtoTypeEnum),
          ) as PostResponseDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PostResponseDtoVisibilityEnum),
          ) as PostResponseDtoVisibilityEnum;
          result.visibility = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PostResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PostResponseDtoBuilder();
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

class PostResponseDtoTypeEnum extends EnumClass {

  /// The type of post
  @BuiltValueEnumConst(wireName: r'POST')
  static const PostResponseDtoTypeEnum POST = _$postResponseDtoTypeEnum_POST;
  /// The type of post
  @BuiltValueEnumConst(wireName: r'REPLY')
  static const PostResponseDtoTypeEnum REPLY = _$postResponseDtoTypeEnum_REPLY;
  /// The type of post
  @BuiltValueEnumConst(wireName: r'QUOTE')
  static const PostResponseDtoTypeEnum QUOTE = _$postResponseDtoTypeEnum_QUOTE;

  static Serializer<PostResponseDtoTypeEnum> get serializer => _$postResponseDtoTypeEnumSerializer;

  const PostResponseDtoTypeEnum._(String name): super(name);

  static BuiltSet<PostResponseDtoTypeEnum> get values => _$postResponseDtoTypeEnumValues;
  static PostResponseDtoTypeEnum valueOf(String name) => _$postResponseDtoTypeEnumValueOf(name);
}

class PostResponseDtoVisibilityEnum extends EnumClass {

  /// The visibility level of the post
  @BuiltValueEnumConst(wireName: r'EVERY_ONE')
  static const PostResponseDtoVisibilityEnum EVERY_ONE = _$postResponseDtoVisibilityEnum_EVERY_ONE;
  /// The visibility level of the post
  @BuiltValueEnumConst(wireName: r'FOLLOWERS')
  static const PostResponseDtoVisibilityEnum FOLLOWERS = _$postResponseDtoVisibilityEnum_FOLLOWERS;
  /// The visibility level of the post
  @BuiltValueEnumConst(wireName: r'MENTIONED')
  static const PostResponseDtoVisibilityEnum MENTIONED = _$postResponseDtoVisibilityEnum_MENTIONED;

  static Serializer<PostResponseDtoVisibilityEnum> get serializer => _$postResponseDtoVisibilityEnumSerializer;

  const PostResponseDtoVisibilityEnum._(String name): super(name);

  static BuiltSet<PostResponseDtoVisibilityEnum> get values => _$postResponseDtoVisibilityEnumValues;
  static PostResponseDtoVisibilityEnum valueOf(String name) => _$postResponseDtoVisibilityEnumValueOf(name);
}

