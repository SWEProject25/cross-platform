//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_post_dto.g.dart';

/// CreatePostDto
///
/// Properties:
/// * [content] - The textual content of the post
/// * [type] - The type of post (POST, REPLY, or QUOTE)
/// * [parentId] - The ID of the parent post (used when this post is a reply or quote)
/// * [visibility] - The visibility level of the post (EVERY_ONE, FOLLOWERS, or MENTIONED)
@BuiltValue()
abstract class CreatePostDto implements Built<CreatePostDto, CreatePostDtoBuilder> {
  /// The textual content of the post
  @BuiltValueField(wireName: r'content')
  String get content;

  /// The type of post (POST, REPLY, or QUOTE)
  @BuiltValueField(wireName: r'type')
  CreatePostDtoTypeEnum get type;
  // enum typeEnum {  POST,  REPLY,  QUOTE,  };

  /// The ID of the parent post (used when this post is a reply or quote)
  @BuiltValueField(wireName: r'parentId')
  num? get parentId;

  /// The visibility level of the post (EVERY_ONE, FOLLOWERS, or MENTIONED)
  @BuiltValueField(wireName: r'visibility')
  CreatePostDtoVisibilityEnum get visibility;
  // enum visibilityEnum {  EVERY_ONE,  FOLLOWERS,  MENTIONED,  };

  CreatePostDto._();

  factory CreatePostDto([void updates(CreatePostDtoBuilder b)]) = _$CreatePostDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatePostDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatePostDto> get serializer => _$CreatePostDtoSerializer();
}

class _$CreatePostDtoSerializer implements PrimitiveSerializer<CreatePostDto> {
  @override
  final Iterable<Type> types = const [CreatePostDto, _$CreatePostDto];

  @override
  final String wireName = r'CreatePostDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatePostDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'content';
    yield serializers.serialize(
      object.content,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(CreatePostDtoTypeEnum),
    );
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(CreatePostDtoVisibilityEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatePostDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatePostDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(CreatePostDtoTypeEnum),
          ) as CreatePostDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatePostDtoVisibilityEnum),
          ) as CreatePostDtoVisibilityEnum;
          result.visibility = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreatePostDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatePostDtoBuilder();
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

class CreatePostDtoTypeEnum extends EnumClass {

  /// The type of post (POST, REPLY, or QUOTE)
  @BuiltValueEnumConst(wireName: r'POST')
  static const CreatePostDtoTypeEnum POST = _$createPostDtoTypeEnum_POST;
  /// The type of post (POST, REPLY, or QUOTE)
  @BuiltValueEnumConst(wireName: r'REPLY')
  static const CreatePostDtoTypeEnum REPLY = _$createPostDtoTypeEnum_REPLY;
  /// The type of post (POST, REPLY, or QUOTE)
  @BuiltValueEnumConst(wireName: r'QUOTE')
  static const CreatePostDtoTypeEnum QUOTE = _$createPostDtoTypeEnum_QUOTE;

  static Serializer<CreatePostDtoTypeEnum> get serializer => _$createPostDtoTypeEnumSerializer;

  const CreatePostDtoTypeEnum._(String name): super(name);

  static BuiltSet<CreatePostDtoTypeEnum> get values => _$createPostDtoTypeEnumValues;
  static CreatePostDtoTypeEnum valueOf(String name) => _$createPostDtoTypeEnumValueOf(name);
}

class CreatePostDtoVisibilityEnum extends EnumClass {

  /// The visibility level of the post (EVERY_ONE, FOLLOWERS, or MENTIONED)
  @BuiltValueEnumConst(wireName: r'EVERY_ONE')
  static const CreatePostDtoVisibilityEnum EVERY_ONE = _$createPostDtoVisibilityEnum_EVERY_ONE;
  /// The visibility level of the post (EVERY_ONE, FOLLOWERS, or MENTIONED)
  @BuiltValueEnumConst(wireName: r'FOLLOWERS')
  static const CreatePostDtoVisibilityEnum FOLLOWERS = _$createPostDtoVisibilityEnum_FOLLOWERS;
  /// The visibility level of the post (EVERY_ONE, FOLLOWERS, or MENTIONED)
  @BuiltValueEnumConst(wireName: r'MENTIONED')
  static const CreatePostDtoVisibilityEnum MENTIONED = _$createPostDtoVisibilityEnum_MENTIONED;

  static Serializer<CreatePostDtoVisibilityEnum> get serializer => _$createPostDtoVisibilityEnumSerializer;

  const CreatePostDtoVisibilityEnum._(String name): super(name);

  static BuiltSet<CreatePostDtoVisibilityEnum> get values => _$createPostDtoVisibilityEnumValues;
  static CreatePostDtoVisibilityEnum valueOf(String name) => _$createPostDtoVisibilityEnumValueOf(name);
}

