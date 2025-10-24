//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_profile_dto.g.dart';

/// UpdateProfileDto
///
/// Properties:
/// * [name] - The name of the user
/// * [birthDate] - The birth date of the user
/// * [profileImageUrl] - URL of the user profile image
/// * [bannerImageUrl] - URL of the user banner image
/// * [bio] - User biography
/// * [location] - User location
/// * [website] - User website URL
@BuiltValue()
abstract class UpdateProfileDto implements Built<UpdateProfileDto, UpdateProfileDtoBuilder> {
  /// The name of the user
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// The birth date of the user
  @BuiltValueField(wireName: r'birth_date')
  Date? get birthDate;

  /// URL of the user profile image
  @BuiltValueField(wireName: r'profile_image_url')
  String? get profileImageUrl;

  /// URL of the user banner image
  @BuiltValueField(wireName: r'banner_image_url')
  String? get bannerImageUrl;

  /// User biography
  @BuiltValueField(wireName: r'bio')
  String? get bio;

  /// User location
  @BuiltValueField(wireName: r'location')
  String? get location;

  /// User website URL
  @BuiltValueField(wireName: r'website')
  String? get website;

  UpdateProfileDto._();

  factory UpdateProfileDto([void updates(UpdateProfileDtoBuilder b)]) = _$UpdateProfileDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProfileDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProfileDto> get serializer => _$UpdateProfileDtoSerializer();
}

class _$UpdateProfileDtoSerializer implements PrimitiveSerializer<UpdateProfileDto> {
  @override
  final Iterable<Type> types = const [UpdateProfileDto, _$UpdateProfileDto];

  @override
  final String wireName = r'UpdateProfileDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProfileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateProfileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateProfileDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateProfileDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProfileDtoBuilder();
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

