//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_liked_posts_response_dto_data_inner.g.dart';

/// GetLikedPostsResponseDtoDataInner
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [content] 
/// * [type] 
/// * [parentId] 
/// * [visibility] 
/// * [createdAt] 
@BuiltValue()
abstract class GetLikedPostsResponseDtoDataInner implements Built<GetLikedPostsResponseDtoDataInner, GetLikedPostsResponseDtoDataInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  num? get id;

  @BuiltValueField(wireName: r'user_id')
  num? get userId;

  @BuiltValueField(wireName: r'content')
  String? get content;

  @BuiltValueField(wireName: r'type')
  String? get type;

  @BuiltValueField(wireName: r'parent_id')
  num? get parentId;

  @BuiltValueField(wireName: r'visibility')
  String? get visibility;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  GetLikedPostsResponseDtoDataInner._();

  factory GetLikedPostsResponseDtoDataInner([void updates(GetLikedPostsResponseDtoDataInnerBuilder b)]) = _$GetLikedPostsResponseDtoDataInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetLikedPostsResponseDtoDataInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetLikedPostsResponseDtoDataInner> get serializer => _$GetLikedPostsResponseDtoDataInnerSerializer();
}

class _$GetLikedPostsResponseDtoDataInnerSerializer implements PrimitiveSerializer<GetLikedPostsResponseDtoDataInner> {
  @override
  final Iterable<Type> types = const [GetLikedPostsResponseDtoDataInner, _$GetLikedPostsResponseDtoDataInner];

  @override
  final String wireName = r'GetLikedPostsResponseDtoDataInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetLikedPostsResponseDtoDataInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(num),
      );
    }
    if (object.userId != null) {
      yield r'user_id';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(num),
      );
    }
    if (object.content != null) {
      yield r'content';
      yield serializers.serialize(
        object.content,
        specifiedType: const FullType(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(String),
      );
    }
    if (object.parentId != null) {
      yield r'parent_id';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.visibility != null) {
      yield r'visibility';
      yield serializers.serialize(
        object.visibility,
        specifiedType: const FullType(String),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GetLikedPostsResponseDtoDataInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetLikedPostsResponseDtoDataInnerBuilder result,
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
        case r'user_id':
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
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'parent_id':
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
            specifiedType: const FullType(String),
          ) as String;
          result.visibility = valueDes;
          break;
        case r'created_at':
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
  GetLikedPostsResponseDtoDataInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetLikedPostsResponseDtoDataInnerBuilder();
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

