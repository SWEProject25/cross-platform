//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_username_dto.g.dart';

/// UpdateUsernameDto
///
/// Properties:
/// * [username] - The new username for the user
@BuiltValue()
abstract class UpdateUsernameDto implements Built<UpdateUsernameDto, UpdateUsernameDtoBuilder> {
  /// The new username for the user
  @BuiltValueField(wireName: r'username')
  String get username;

  UpdateUsernameDto._();

  factory UpdateUsernameDto([void updates(UpdateUsernameDtoBuilder b)]) = _$UpdateUsernameDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateUsernameDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateUsernameDto> get serializer => _$UpdateUsernameDtoSerializer();
}

class _$UpdateUsernameDtoSerializer implements PrimitiveSerializer<UpdateUsernameDto> {
  @override
  final Iterable<Type> types = const [UpdateUsernameDto, _$UpdateUsernameDto];

  @override
  final String wireName = r'UpdateUsernameDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateUsernameDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateUsernameDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateUsernameDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateUsernameDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateUsernameDtoBuilder();
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

