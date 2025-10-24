//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/user_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_likers_response_dto.g.dart';

/// GetLikersResponseDto
///
/// Properties:
/// * [status] - Status of the response
/// * [message] - Response message
/// * [data] - Array of users who liked the post
@BuiltValue()
abstract class GetLikersResponseDto implements Built<GetLikersResponseDto, GetLikersResponseDtoBuilder> {
  /// Status of the response
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Array of users who liked the post
  @BuiltValueField(wireName: r'data')
  BuiltList<UserDto> get data;

  GetLikersResponseDto._();

  factory GetLikersResponseDto([void updates(GetLikersResponseDtoBuilder b)]) = _$GetLikersResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetLikersResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetLikersResponseDto> get serializer => _$GetLikersResponseDtoSerializer();
}

class _$GetLikersResponseDtoSerializer implements PrimitiveSerializer<GetLikersResponseDto> {
  @override
  final Iterable<Type> types = const [GetLikersResponseDto, _$GetLikersResponseDto];

  @override
  final String wireName = r'GetLikersResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetLikersResponseDto object, {
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
      specifiedType: const FullType(BuiltList, [FullType(UserDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetLikersResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetLikersResponseDtoBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(UserDto)]),
          ) as BuiltList<UserDto>;
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
  GetLikersResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetLikersResponseDtoBuilder();
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

