//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recaptcha_dto.g.dart';

/// RecaptchaDto
///
/// Properties:
/// * [recaptcha] - The Google reCAPTCHA response token from the client.
@BuiltValue()
abstract class RecaptchaDto implements Built<RecaptchaDto, RecaptchaDtoBuilder> {
  /// The Google reCAPTCHA response token from the client.
  @BuiltValueField(wireName: r'recaptcha')
  String get recaptcha;

  RecaptchaDto._();

  factory RecaptchaDto([void updates(RecaptchaDtoBuilder b)]) = _$RecaptchaDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecaptchaDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecaptchaDto> get serializer => _$RecaptchaDtoSerializer();
}

class _$RecaptchaDtoSerializer implements PrimitiveSerializer<RecaptchaDto> {
  @override
  final Iterable<Type> types = const [RecaptchaDto, _$RecaptchaDto];

  @override
  final String wireName = r'RecaptchaDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecaptchaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recaptcha';
    yield serializers.serialize(
      object.recaptcha,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecaptchaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RecaptchaDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recaptcha':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recaptcha = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecaptchaDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecaptchaDtoBuilder();
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

