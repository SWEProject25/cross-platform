//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'repost_user_dto.g.dart';

/// RepostUserDto
///
/// Properties:
/// * [id] - The unique identifier of the user
/// * [username] - The username of the user
/// * [email] - The email of the user
/// * [isVerified] - Whether the user is verified
@BuiltValue()
abstract class RepostUserDto implements Built<RepostUserDto, RepostUserDtoBuilder> {
  /// The unique identifier of the user
  @BuiltValueField(wireName: r'id')
  num get id;

  /// The username of the user
  @BuiltValueField(wireName: r'username')
  String get username;

  /// The email of the user
  @BuiltValueField(wireName: r'email')
  String get email;

  /// Whether the user is verified
  @BuiltValueField(wireName: r'is_verified')
  bool get isVerified;

  RepostUserDto._();

  factory RepostUserDto([void updates(RepostUserDtoBuilder b)]) = _$RepostUserDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RepostUserDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RepostUserDto> get serializer => _$RepostUserDtoSerializer();
}

class _$RepostUserDtoSerializer implements PrimitiveSerializer<RepostUserDto> {
  @override
  final Iterable<Type> types = const [RepostUserDto, _$RepostUserDto];

  @override
  final String wireName = r'RepostUserDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RepostUserDto object, {
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
    yield r'is_verified';
    yield serializers.serialize(
      object.isVerified,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RepostUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RepostUserDtoBuilder result,
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
        case r'is_verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVerified = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RepostUserDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RepostUserDtoBuilder();
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

