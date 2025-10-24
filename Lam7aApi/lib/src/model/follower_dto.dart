//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'follower_dto.g.dart';

/// FollowerDto
///
/// Properties:
/// * [id] - User ID
/// * [username] - Username
/// * [displayName] - Display name
/// * [bio] - User bio
/// * [profileImageUrl] - Profile image URL
/// * [followedAt] - Date when the follow relationship was created
@BuiltValue()
abstract class FollowerDto implements Built<FollowerDto, FollowerDtoBuilder> {
  /// User ID
  @BuiltValueField(wireName: r'id')
  num get id;

  /// Username
  @BuiltValueField(wireName: r'username')
  String get username;

  /// Display name
  @BuiltValueField(wireName: r'displayName')
  JsonObject? get displayName;

  /// User bio
  @BuiltValueField(wireName: r'bio')
  JsonObject? get bio;

  /// Profile image URL
  @BuiltValueField(wireName: r'profileImageUrl')
  JsonObject? get profileImageUrl;

  /// Date when the follow relationship was created
  @BuiltValueField(wireName: r'followedAt')
  DateTime get followedAt;

  FollowerDto._();

  factory FollowerDto([void updates(FollowerDtoBuilder b)]) = _$FollowerDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FollowerDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FollowerDto> get serializer => _$FollowerDtoSerializer();
}

class _$FollowerDtoSerializer implements PrimitiveSerializer<FollowerDto> {
  @override
  final Iterable<Type> types = const [FollowerDto, _$FollowerDto];

  @override
  final String wireName = r'FollowerDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FollowerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(num),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield object.displayName == null ? null : serializers.serialize(
      object.displayName,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'bio';
    yield object.bio == null ? null : serializers.serialize(
      object.bio,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'profileImageUrl';
    yield object.profileImageUrl == null ? null : serializers.serialize(
      object.profileImageUrl,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'followedAt';
    yield serializers.serialize(
      object.followedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FollowerDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FollowerDtoBuilder result,
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
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'bio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.bio = valueDes;
          break;
        case r'profileImageUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.profileImageUrl = valueDes;
          break;
        case r'followedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.followedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FollowerDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FollowerDtoBuilder();
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

