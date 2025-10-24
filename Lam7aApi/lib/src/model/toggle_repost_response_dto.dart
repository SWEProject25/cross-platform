//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'toggle_repost_response_dto.g.dart';

/// ToggleRepostResponseDto
///
/// Properties:
/// * [status] - Status of the response
/// * [message] - Response message
/// * [data] - The toggle repost result
@BuiltValue()
abstract class ToggleRepostResponseDto implements Built<ToggleRepostResponseDto, ToggleRepostResponseDtoBuilder> {
  /// Status of the response
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// The toggle repost result
  @BuiltValueField(wireName: r'data')
  JsonObject get data;

  ToggleRepostResponseDto._();

  factory ToggleRepostResponseDto([void updates(ToggleRepostResponseDtoBuilder b)]) = _$ToggleRepostResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ToggleRepostResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ToggleRepostResponseDto> get serializer => _$ToggleRepostResponseDtoSerializer();
}

class _$ToggleRepostResponseDtoSerializer implements PrimitiveSerializer<ToggleRepostResponseDto> {
  @override
  final Iterable<Type> types = const [ToggleRepostResponseDto, _$ToggleRepostResponseDto];

  @override
  final String wireName = r'ToggleRepostResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ToggleRepostResponseDto object, {
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
    ToggleRepostResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ToggleRepostResponseDtoBuilder result,
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
  ToggleRepostResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ToggleRepostResponseDtoBuilder();
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

