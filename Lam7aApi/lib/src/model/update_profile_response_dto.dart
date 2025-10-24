//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/profile_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_profile_response_dto.g.dart';

/// UpdateProfileResponseDto
///
/// Properties:
/// * [status] - Response status
/// * [message] - Response message
/// * [data] - Updated profile data
@BuiltValue()
abstract class UpdateProfileResponseDto implements Built<UpdateProfileResponseDto, UpdateProfileResponseDtoBuilder> {
  /// Response status
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Updated profile data
  @BuiltValueField(wireName: r'data')
  ProfileResponseDto get data;

  UpdateProfileResponseDto._();

  factory UpdateProfileResponseDto([void updates(UpdateProfileResponseDtoBuilder b)]) = _$UpdateProfileResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProfileResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProfileResponseDto> get serializer => _$UpdateProfileResponseDtoSerializer();
}

class _$UpdateProfileResponseDtoSerializer implements PrimitiveSerializer<UpdateProfileResponseDto> {
  @override
  final Iterable<Type> types = const [UpdateProfileResponseDto, _$UpdateProfileResponseDto];

  @override
  final String wireName = r'UpdateProfileResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProfileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(ProfileResponseDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateProfileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateProfileResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProfileResponseDto),
          ) as ProfileResponseDto;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateProfileResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProfileResponseDtoBuilder();
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

