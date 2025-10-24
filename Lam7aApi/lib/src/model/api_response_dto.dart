//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_response_dto.g.dart';

/// ApiResponseDto
///
/// Properties:
/// * [status] - The status of the response
/// * [message] - A descriptive message about the response
/// * [data] - The data payload of the response
@BuiltValue()
abstract class ApiResponseDto implements Built<ApiResponseDto, ApiResponseDtoBuilder> {
  /// The status of the response
  @BuiltValueField(wireName: r'status')
  ApiResponseDtoStatusEnum get status;
  // enum statusEnum {  success,  error,  fail,  };

  /// A descriptive message about the response
  @BuiltValueField(wireName: r'message')
  String get message;

  /// The data payload of the response
  @BuiltValueField(wireName: r'data')
  JsonObject? get data;

  ApiResponseDto._();

  factory ApiResponseDto([void updates(ApiResponseDtoBuilder b)]) = _$ApiResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiResponseDto> get serializer => _$ApiResponseDtoSerializer();
}

class _$ApiResponseDtoSerializer implements PrimitiveSerializer<ApiResponseDto> {
  @override
  final Iterable<Type> types = const [ApiResponseDto, _$ApiResponseDto];

  @override
  final String wireName = r'ApiResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ApiResponseDtoStatusEnum),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'data';
    yield object.data == null ? null : serializers.serialize(
      object.data,
      specifiedType: const FullType.nullable(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiResponseDtoStatusEnum),
          ) as ApiResponseDtoStatusEnum;
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
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.data = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiResponseDtoBuilder();
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

class ApiResponseDtoStatusEnum extends EnumClass {

  /// The status of the response
  @BuiltValueEnumConst(wireName: r'success')
  static const ApiResponseDtoStatusEnum success = _$apiResponseDtoStatusEnum_success;
  /// The status of the response
  @BuiltValueEnumConst(wireName: r'error')
  static const ApiResponseDtoStatusEnum error = _$apiResponseDtoStatusEnum_error;
  /// The status of the response
  @BuiltValueEnumConst(wireName: r'fail')
  static const ApiResponseDtoStatusEnum fail = _$apiResponseDtoStatusEnum_fail;

  static Serializer<ApiResponseDtoStatusEnum> get serializer => _$apiResponseDtoStatusEnumSerializer;

  const ApiResponseDtoStatusEnum._(String name): super(name);

  static BuiltSet<ApiResponseDtoStatusEnum> get values => _$apiResponseDtoStatusEnumValues;
  static ApiResponseDtoStatusEnum valueOf(String name) => _$apiResponseDtoStatusEnumValueOf(name);
}

