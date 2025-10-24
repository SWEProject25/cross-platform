//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/profile_response_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_profile_response_dto.g.dart';

/// GetProfileResponseDto
///
/// Properties:
/// * [status] - Response status
/// * [message] - Response message
/// * [data] - Profile data
@BuiltValue()
abstract class GetProfileResponseDto implements Built<GetProfileResponseDto, GetProfileResponseDtoBuilder> {
  /// Response status
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Profile data
  @BuiltValueField(wireName: r'data')
  ProfileResponseDto get data;

  GetProfileResponseDto._();

  factory GetProfileResponseDto([void updates(GetProfileResponseDtoBuilder b)]) = _$GetProfileResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetProfileResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetProfileResponseDto> get serializer => _$GetProfileResponseDtoSerializer();
}

class _$GetProfileResponseDtoSerializer implements PrimitiveSerializer<GetProfileResponseDto> {
  @override
  final Iterable<Type> types = const [GetProfileResponseDto, _$GetProfileResponseDto];

  @override
  final String wireName = r'GetProfileResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetProfileResponseDto object, {
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
    GetProfileResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetProfileResponseDtoBuilder result,
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
  GetProfileResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetProfileResponseDtoBuilder();
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

