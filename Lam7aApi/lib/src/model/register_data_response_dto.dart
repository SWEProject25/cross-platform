//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_data_response_dto.g.dart';

/// RegisterDataResponseDto
///
/// Properties:
/// * [user] 
@BuiltValue()
abstract class RegisterDataResponseDto implements Built<RegisterDataResponseDto, RegisterDataResponseDtoBuilder> {
  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  RegisterDataResponseDto._();

  factory RegisterDataResponseDto([void updates(RegisterDataResponseDtoBuilder b)]) = _$RegisterDataResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterDataResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterDataResponseDto> get serializer => _$RegisterDataResponseDtoSerializer();
}

class _$RegisterDataResponseDtoSerializer implements PrimitiveSerializer<RegisterDataResponseDto> {
  @override
  final Iterable<Type> types = const [RegisterDataResponseDto, _$RegisterDataResponseDto];

  @override
  final String wireName = r'RegisterDataResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterDataResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterDataResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterDataResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
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
  RegisterDataResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterDataResponseDtoBuilder();
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

