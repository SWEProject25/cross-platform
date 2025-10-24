//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_email_dto.g.dart';

/// UpdateEmailDto
///
/// Properties:
/// * [email] - The new email address for the user
@BuiltValue()
abstract class UpdateEmailDto implements Built<UpdateEmailDto, UpdateEmailDtoBuilder> {
  /// The new email address for the user
  @BuiltValueField(wireName: r'email')
  String get email;

  UpdateEmailDto._();

  factory UpdateEmailDto([void updates(UpdateEmailDtoBuilder b)]) = _$UpdateEmailDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateEmailDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateEmailDto> get serializer => _$UpdateEmailDtoSerializer();
}

class _$UpdateEmailDtoSerializer implements PrimitiveSerializer<UpdateEmailDto> {
  @override
  final Iterable<Type> types = const [UpdateEmailDto, _$UpdateEmailDto];

  @override
  final String wireName = r'UpdateEmailDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateEmailDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateEmailDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateEmailDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateEmailDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateEmailDtoBuilder();
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

