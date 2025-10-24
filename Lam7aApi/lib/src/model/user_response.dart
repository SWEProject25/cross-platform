//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_response.g.dart';

/// UserResponse
///
/// Properties:
/// * [username] - The unique username of the user
/// * [email] - Email address of the user
/// * [role] - Role assigned to the user
/// * [name] - Full name of the user
/// * [birthDate] - Birth date of the user
/// * [profileImageUrl] - Profile image URL of the user
/// * [bannerImageUrl] - Banner image URL of the user
/// * [bio] - Short bio or description of the user
/// * [location] - User location
/// * [website] - User’s personal website URL
/// * [createdAt] - Account creation date
@BuiltValue()
abstract class UserResponse implements Built<UserResponse, UserResponseBuilder> {
  /// The unique username of the user
  @BuiltValueField(wireName: r'username')
  String get username;

  /// Email address of the user
  @BuiltValueField(wireName: r'email')
  String? get email;

  /// Role assigned to the user
  @BuiltValueField(wireName: r'role')
  String? get role;

  /// Full name of the user
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Birth date of the user
  @BuiltValueField(wireName: r'birth_date')
  Date? get birthDate;

  /// Profile image URL of the user
  @BuiltValueField(wireName: r'profile_image_url')
  JsonObject? get profileImageUrl;

  /// Banner image URL of the user
  @BuiltValueField(wireName: r'banner_image_url')
  JsonObject? get bannerImageUrl;

  /// Short bio or description of the user
  @BuiltValueField(wireName: r'bio')
  JsonObject? get bio;

  /// User location
  @BuiltValueField(wireName: r'location')
  JsonObject? get location;

  /// User’s personal website URL
  @BuiltValueField(wireName: r'website')
  JsonObject? get website;

  /// Account creation date
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  UserResponse._();

  factory UserResponse([void updates(UserResponseBuilder b)]) = _$UserResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserResponse> get serializer => _$UserResponseSerializer();
}

class _$UserResponseSerializer implements PrimitiveSerializer<UserResponse> {
  @override
  final Iterable<Type> types = const [UserResponse, _$UserResponse];

  @override
  final String wireName = r'UserResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      );
    }
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.birthDate != null) {
      yield r'birth_date';
      yield serializers.serialize(
        object.birthDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.profileImageUrl != null) {
      yield r'profile_image_url';
      yield serializers.serialize(
        object.profileImageUrl,
        specifiedType: const FullType(JsonObject),
      );
    }
    if (object.bannerImageUrl != null) {
      yield r'banner_image_url';
      yield serializers.serialize(
        object.bannerImageUrl,
        specifiedType: const FullType(JsonObject),
      );
    }
    if (object.bio != null) {
      yield r'bio';
      yield serializers.serialize(
        object.bio,
        specifiedType: const FullType(JsonObject),
      );
    }
    if (object.location != null) {
      yield r'location';
      yield serializers.serialize(
        object.location,
        specifiedType: const FullType(JsonObject),
      );
    }
    if (object.website != null) {
      yield r'website';
      yield serializers.serialize(
        object.website,
        specifiedType: const FullType(JsonObject),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'birth_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.birthDate = valueDes;
          break;
        case r'profile_image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.profileImageUrl = valueDes;
          break;
        case r'banner_image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.bannerImageUrl = valueDes;
          break;
        case r'bio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.bio = valueDes;
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.location = valueDes;
          break;
        case r'website':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.website = valueDes;
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
  UserResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserResponseBuilder();
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

