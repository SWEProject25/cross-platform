//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_post_response_dto.g.dart';

/// DeletePostResponseDto
///
/// Properties:
/// * [status] - Status of the response
/// * [message] - Response message
@BuiltValue()
abstract class DeletePostResponseDto implements Built<DeletePostResponseDto, DeletePostResponseDtoBuilder> {
  /// Status of the response
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  DeletePostResponseDto._();

  factory DeletePostResponseDto([void updates(DeletePostResponseDtoBuilder b)]) = _$DeletePostResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeletePostResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeletePostResponseDto> get serializer => _$DeletePostResponseDtoSerializer();
}

class _$DeletePostResponseDtoSerializer implements PrimitiveSerializer<DeletePostResponseDto> {
  @override
  final Iterable<Type> types = const [DeletePostResponseDto, _$DeletePostResponseDto];

  @override
  final String wireName = r'DeletePostResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeletePostResponseDto object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DeletePostResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeletePostResponseDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeletePostResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeletePostResponseDtoBuilder();
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

