//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_info_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile_response_dto.g.dart';

/// ProfileResponseDto
///
/// Properties:
/// * [id] - Profile ID
/// * [userId] - User ID associated with this profile
/// * [name] - User name
/// * [birthDate] - User birth date
/// * [profileImageUrl] - Profile image URL
/// * [bannerImageUrl] - Banner image URL
/// * [bio] - User bio
/// * [location] - User location
/// * [website] - User website
/// * [isDeactivated] - Whether the profile is deactivated
/// * [createdAt] - Profile creation timestamp
/// * [updatedAt] - Profile last update timestamp
/// * [user] - Associated user information
@BuiltValue()
abstract class ProfileResponseDto implements Built<ProfileResponseDto, ProfileResponseDtoBuilder> {
  /// Profile ID
  @BuiltValueField(wireName: r'id')
  num get id;

  /// User ID associated with this profile
  @BuiltValueField(wireName: r'user_id')
  num get userId;

  /// User name
  @BuiltValueField(wireName: r'name')
  String get name;

  /// User birth date
  @BuiltValueField(wireName: r'birth_date')
  DateTime get birthDate;

  /// Profile image URL
  @BuiltValueField(wireName: r'profile_image_url')
  String? get profileImageUrl;

  /// Banner image URL
  @BuiltValueField(wireName: r'banner_image_url')
  String? get bannerImageUrl;

  /// User bio
  @BuiltValueField(wireName: r'bio')
  String? get bio;

  /// User location
  @BuiltValueField(wireName: r'location')
  String? get location;

  /// User website
  @BuiltValueField(wireName: r'website')
  String? get website;

  /// Whether the profile is deactivated
  @BuiltValueField(wireName: r'is_deactivated')
  bool? get isDeactivated;

  /// Profile creation timestamp
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// Profile last update timestamp
  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  /// Associated user information
  @BuiltValueField(wireName: r'User')
  UserInfoDto get user;

  ProfileResponseDto._();

  factory ProfileResponseDto([void updates(ProfileResponseDtoBuilder b)]) = _$ProfileResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileResponseDto> get serializer => _$ProfileResponseDtoSerializer();
}

class _$ProfileResponseDtoSerializer implements PrimitiveSerializer<ProfileResponseDto> {
  @override
  final Iterable<Type> types = const [ProfileResponseDto, _$ProfileResponseDto];

  @override
  final String wireName = r'ProfileResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(num),
    );
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(num),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'birth_date';
    yield serializers.serialize(
      object.birthDate,
      specifiedType: const FullType(DateTime),
    );
    if (object.profileImageUrl != null) {
      yield r'profile_image_url';
      yield serializers.serialize(
        object.profileImageUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.bannerImageUrl != null) {
      yield r'banner_image_url';
      yield serializers.serialize(
        object.bannerImageUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.bio != null) {
      yield r'bio';
      yield serializers.serialize(
        object.bio,
        specifiedType: const FullType(String),
      );
    }
    if (object.location != null) {
      yield r'location';
      yield serializers.serialize(
        object.location,
        specifiedType: const FullType(String),
      );
    }
    if (object.website != null) {
      yield r'website';
      yield serializers.serialize(
        object.website,
        specifiedType: const FullType(String),
      );
    }
    if (object.isDeactivated != null) {
      yield r'is_deactivated';
      yield serializers.serialize(
        object.isDeactivated,
        specifiedType: const FullType(bool),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'User';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserInfoDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProfileResponseDtoBuilder result,
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
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.birthDate = valueDes;
          break;
        case r'profile_image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.profileImageUrl = valueDes;
          break;
        case r'banner_image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bannerImageUrl = valueDes;
          break;
        case r'bio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bio = valueDes;
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.location = valueDes;
          break;
        case r'website':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.website = valueDes;
          break;
        case r'is_deactivated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDeactivated = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'User':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserInfoDto),
          ) as UserInfoDto;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfileResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileResponseDtoBuilder();
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

