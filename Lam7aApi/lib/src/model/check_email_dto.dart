//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'check_email_dto.g.dart';

/// CheckEmailDto
///
/// Properties:
/// * [email] - The email address to check for existence
@BuiltValue()
abstract class CheckEmailDto implements Built<CheckEmailDto, CheckEmailDtoBuilder> {
  /// The email address to check for existence
  @BuiltValueField(wireName: r'email')
  String get email;

  CheckEmailDto._();

  factory CheckEmailDto([void updates(CheckEmailDtoBuilder b)]) = _$CheckEmailDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckEmailDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckEmailDto> get serializer => _$CheckEmailDtoSerializer();
}

class _$CheckEmailDtoSerializer implements PrimitiveSerializer<CheckEmailDto> {
  @override
  final Iterable<Type> types = const [CheckEmailDto, _$CheckEmailDto];

  @override
  final String wireName = r'CheckEmailDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckEmailDto object, {
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
    CheckEmailDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckEmailDtoBuilder result,
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
  CheckEmailDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckEmailDtoBuilder();
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

