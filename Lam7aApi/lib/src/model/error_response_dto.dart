//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'error_response_dto.g.dart';

/// ErrorResponseDto
///
/// Properties:
/// * [status] 
/// * [message] 
/// * [error] - Optional error details or the type of error
@BuiltValue()
abstract class ErrorResponseDto implements Built<ErrorResponseDto, ErrorResponseDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  ErrorResponseDtoStatusEnum get status;
  // enum statusEnum {  error,  fail,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  /// Optional error details or the type of error
  @BuiltValueField(wireName: r'error')
  JsonObject? get error;

  ErrorResponseDto._();

  factory ErrorResponseDto([void updates(ErrorResponseDtoBuilder b)]) = _$ErrorResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ErrorResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ErrorResponseDto> get serializer => _$ErrorResponseDtoSerializer();
}

class _$ErrorResponseDtoSerializer implements PrimitiveSerializer<ErrorResponseDto> {
  @override
  final Iterable<Type> types = const [ErrorResponseDto, _$ErrorResponseDto];

  @override
  final String wireName = r'ErrorResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ErrorResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ErrorResponseDtoStatusEnum),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'error';
    yield object.error == null ? null : serializers.serialize(
      object.error,
      specifiedType: const FullType.nullable(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ErrorResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ErrorResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ErrorResponseDtoStatusEnum),
          ) as ErrorResponseDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ErrorResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ErrorResponseDtoBuilder();
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

class ErrorResponseDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'error')
  static const ErrorResponseDtoStatusEnum error = _$errorResponseDtoStatusEnum_error;
  @BuiltValueEnumConst(wireName: r'fail')
  static const ErrorResponseDtoStatusEnum fail = _$errorResponseDtoStatusEnum_fail;

  static Serializer<ErrorResponseDtoStatusEnum> get serializer => _$errorResponseDtoStatusEnumSerializer;

  const ErrorResponseDtoStatusEnum._(String name): super(name);

  static BuiltSet<ErrorResponseDtoStatusEnum> get values => _$errorResponseDtoStatusEnumValues;
  static ErrorResponseDtoStatusEnum valueOf(String name) => _$errorResponseDtoStatusEnumValueOf(name);
}

