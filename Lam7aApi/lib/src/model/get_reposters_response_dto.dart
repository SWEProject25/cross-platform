//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/repost_user_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_reposters_response_dto.g.dart';

/// GetRepostersResponseDto
///
/// Properties:
/// * [status] - Status of the response
/// * [message] - Response message
/// * [data] - Array of users who reposted the post
@BuiltValue()
abstract class GetRepostersResponseDto implements Built<GetRepostersResponseDto, GetRepostersResponseDtoBuilder> {
  /// Status of the response
  @BuiltValueField(wireName: r'status')
  String get status;

  /// Response message
  @BuiltValueField(wireName: r'message')
  String get message;

  /// Array of users who reposted the post
  @BuiltValueField(wireName: r'data')
  BuiltList<RepostUserDto> get data;

  GetRepostersResponseDto._();

  factory GetRepostersResponseDto([void updates(GetRepostersResponseDtoBuilder b)]) = _$GetRepostersResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetRepostersResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetRepostersResponseDto> get serializer => _$GetRepostersResponseDtoSerializer();
}

class _$GetRepostersResponseDtoSerializer implements PrimitiveSerializer<GetRepostersResponseDto> {
  @override
  final Iterable<Type> types = const [GetRepostersResponseDto, _$GetRepostersResponseDto];

  @override
  final String wireName = r'GetRepostersResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetRepostersResponseDto object, {
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
      specifiedType: const FullType(BuiltList, [FullType(RepostUserDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetRepostersResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetRepostersResponseDtoBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(RepostUserDto)]),
          ) as BuiltList<RepostUserDto>;
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
  GetRepostersResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetRepostersResponseDtoBuilder();
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

