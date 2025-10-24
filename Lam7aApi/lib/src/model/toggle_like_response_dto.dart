//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'toggle_like_response_dto.g.dart';

/// ToggleLikeResponseDto
///
/// Properties:
/// * [status] - Status of the response
/// * [message] - Response message
/// * [data] - The toggle like result
@BuiltValue()
abstract class ToggleLikeResponseDto implements Built<ToggleLikeResponseDto, ToggleLikeResponseDtoBuilder> {
  /// Status of the response
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// The toggle like result
  @BuiltValueField(wireName: r'data')
  JsonObject get data;

  ToggleLikeResponseDto._();

  factory ToggleLikeResponseDto([void updates(ToggleLikeResponseDtoBuilder b)]) = _$ToggleLikeResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ToggleLikeResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ToggleLikeResponseDto> get serializer => _$ToggleLikeResponseDtoSerializer();
}

class _$ToggleLikeResponseDtoSerializer implements PrimitiveSerializer<ToggleLikeResponseDto> {
  @override
  final Iterable<Type> types = const [ToggleLikeResponseDto, _$ToggleLikeResponseDto];

  @override
  final String wireName = r'ToggleLikeResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ToggleLikeResponseDto object, {
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
      specifiedType: const FullType(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ToggleLikeResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ToggleLikeResponseDtoBuilder result,
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
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
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
  ToggleLikeResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ToggleLikeResponseDtoBuilder();
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

