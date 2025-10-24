//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pagination_metadata.g.dart';

/// PaginationMetadata
///
/// Properties:
/// * [total] - Total number of results
/// * [page] - Current page number
/// * [limit] - Number of items per page
/// * [totalPages] - Total number of pages
@BuiltValue()
abstract class PaginationMetadata implements Built<PaginationMetadata, PaginationMetadataBuilder> {
  /// Total number of results
  @BuiltValueField(wireName: r'total')
  num get total;

  /// Current page number
  @BuiltValueField(wireName: r'page')
  num get page;

  /// Number of items per page
  @BuiltValueField(wireName: r'limit')
  num get limit;

  /// Total number of pages
  @BuiltValueField(wireName: r'totalPages')
  num get totalPages;

  PaginationMetadata._();

  factory PaginationMetadata([void updates(PaginationMetadataBuilder b)]) = _$PaginationMetadata;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaginationMetadataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaginationMetadata> get serializer => _$PaginationMetadataSerializer();
}

class _$PaginationMetadataSerializer implements PrimitiveSerializer<PaginationMetadata> {
  @override
  final Iterable<Type> types = const [PaginationMetadata, _$PaginationMetadata];

  @override
  final String wireName = r'PaginationMetadata';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaginationMetadata object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(num),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(num),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(num),
    );
    yield r'totalPages';
    yield serializers.serialize(
      object.totalPages,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaginationMetadata object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaginationMetadataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.total = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.page = valueDes;
          break;
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.limit = valueDes;
          break;
        case r'totalPages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalPages = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaginationMetadata deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaginationMetadataBuilder();
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

