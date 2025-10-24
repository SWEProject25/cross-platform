//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_info_dto.g.dart';

/// UserInfoDto
///
/// Properties:
/// * [id] - User ID
/// * [username] - Username
/// * [email] - User email
/// * [role] - User role
/// * [createdAt] - Account creation timestamp
@BuiltValue()
abstract class UserInfoDto implements Built<UserInfoDto, UserInfoDtoBuilder> {
  /// User ID
  @BuiltValueField(wireName: r'id')
  num get id;

  /// Username
  @BuiltValueField(wireName: r'username')
  String get username;

  /// User email
  @BuiltValueField(wireName: r'email')
  String get email;

  /// User role
  @BuiltValueField(wireName: r'role')
  UserInfoDtoRoleEnum get role;
  // enum roleEnum {  USER,  ADMIN,  };

  /// Account creation timestamp
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  UserInfoDto._();

  factory UserInfoDto([void updates(UserInfoDtoBuilder b)]) = _$UserInfoDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserInfoDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserInfoDto> get serializer => _$UserInfoDtoSerializer();
}

class _$UserInfoDtoSerializer implements PrimitiveSerializer<UserInfoDto> {
  @override
  final Iterable<Type> types = const [UserInfoDto, _$UserInfoDto];

  @override
  final String wireName = r'UserInfoDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserInfoDto object, {
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
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(UserInfoDtoRoleEnum),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserInfoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserInfoDtoBuilder result,
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
            specifiedType: const FullType(UserInfoDtoRoleEnum),
          ) as UserInfoDtoRoleEnum;
          result.role = valueDes;
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
  UserInfoDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserInfoDtoBuilder();
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

class UserInfoDtoRoleEnum extends EnumClass {

  /// User role
  @BuiltValueEnumConst(wireName: r'USER')
  static const UserInfoDtoRoleEnum USER = _$userInfoDtoRoleEnum_USER;
  /// User role
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const UserInfoDtoRoleEnum ADMIN = _$userInfoDtoRoleEnum_ADMIN;

  static Serializer<UserInfoDtoRoleEnum> get serializer => _$userInfoDtoRoleEnumSerializer;

  const UserInfoDtoRoleEnum._(String name): super(name);

  static BuiltSet<UserInfoDtoRoleEnum> get values => _$userInfoDtoRoleEnumValues;
  static UserInfoDtoRoleEnum valueOf(String name) => _$userInfoDtoRoleEnumValueOf(name);
}

