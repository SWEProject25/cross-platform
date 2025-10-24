//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'follow_response_dto.g.dart';

/// FollowResponseDto
///
/// Properties:
/// * [followerId] - The ID of the user who is following
/// * [followingId] - The ID of the user being followed
/// * [createdAt] - The date and time when the follow was created
@BuiltValue()
abstract class FollowResponseDto implements Built<FollowResponseDto, FollowResponseDtoBuilder> {
  /// The ID of the user who is following
  @BuiltValueField(wireName: r'followerId')
  num get followerId;

  /// The ID of the user being followed
  @BuiltValueField(wireName: r'followingId')
  num get followingId;

  /// The date and time when the follow was created
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  FollowResponseDto._();

  factory FollowResponseDto([void updates(FollowResponseDtoBuilder b)]) = _$FollowResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FollowResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FollowResponseDto> get serializer => _$FollowResponseDtoSerializer();
}

class _$FollowResponseDtoSerializer implements PrimitiveSerializer<FollowResponseDto> {
  @override
  final Iterable<Type> types = const [FollowResponseDto, _$FollowResponseDto];

  @override
  final String wireName = r'FollowResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FollowResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'followerId';
    yield serializers.serialize(
      object.followerId,
      specifiedType: const FullType(num),
    );
    yield r'followingId';
    yield serializers.serialize(
      object.followingId,
      specifiedType: const FullType(num),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FollowResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FollowResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'followerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.followerId = valueDes;
          break;
        case r'followingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.followingId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FollowResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FollowResponseDtoBuilder();
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

