// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatePostDtoTypeEnum _$createPostDtoTypeEnum_POST =
    const CreatePostDtoTypeEnum._('POST');
const CreatePostDtoTypeEnum _$createPostDtoTypeEnum_REPLY =
    const CreatePostDtoTypeEnum._('REPLY');
const CreatePostDtoTypeEnum _$createPostDtoTypeEnum_QUOTE =
    const CreatePostDtoTypeEnum._('QUOTE');

CreatePostDtoTypeEnum _$createPostDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'POST':
      return _$createPostDtoTypeEnum_POST;
    case 'REPLY':
      return _$createPostDtoTypeEnum_REPLY;
    case 'QUOTE':
      return _$createPostDtoTypeEnum_QUOTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatePostDtoTypeEnum> _$createPostDtoTypeEnumValues =
    BuiltSet<CreatePostDtoTypeEnum>(const <CreatePostDtoTypeEnum>[
  _$createPostDtoTypeEnum_POST,
  _$createPostDtoTypeEnum_REPLY,
  _$createPostDtoTypeEnum_QUOTE,
]);

const CreatePostDtoVisibilityEnum _$createPostDtoVisibilityEnum_EVERY_ONE =
    const CreatePostDtoVisibilityEnum._('EVERY_ONE');
const CreatePostDtoVisibilityEnum _$createPostDtoVisibilityEnum_FOLLOWERS =
    const CreatePostDtoVisibilityEnum._('FOLLOWERS');
const CreatePostDtoVisibilityEnum _$createPostDtoVisibilityEnum_MENTIONED =
    const CreatePostDtoVisibilityEnum._('MENTIONED');

CreatePostDtoVisibilityEnum _$createPostDtoVisibilityEnumValueOf(String name) {
  switch (name) {
    case 'EVERY_ONE':
      return _$createPostDtoVisibilityEnum_EVERY_ONE;
    case 'FOLLOWERS':
      return _$createPostDtoVisibilityEnum_FOLLOWERS;
    case 'MENTIONED':
      return _$createPostDtoVisibilityEnum_MENTIONED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatePostDtoVisibilityEnum>
    _$createPostDtoVisibilityEnumValues =
    BuiltSet<CreatePostDtoVisibilityEnum>(const <CreatePostDtoVisibilityEnum>[
  _$createPostDtoVisibilityEnum_EVERY_ONE,
  _$createPostDtoVisibilityEnum_FOLLOWERS,
  _$createPostDtoVisibilityEnum_MENTIONED,
]);

Serializer<CreatePostDtoTypeEnum> _$createPostDtoTypeEnumSerializer =
    _$CreatePostDtoTypeEnumSerializer();
Serializer<CreatePostDtoVisibilityEnum>
    _$createPostDtoVisibilityEnumSerializer =
    _$CreatePostDtoVisibilityEnumSerializer();

class _$CreatePostDtoTypeEnumSerializer
    implements PrimitiveSerializer<CreatePostDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'POST': 'POST',
    'REPLY': 'REPLY',
    'QUOTE': 'QUOTE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'POST': 'POST',
    'REPLY': 'REPLY',
    'QUOTE': 'QUOTE',
  };

  @override
  final Iterable<Type> types = const <Type>[CreatePostDtoTypeEnum];
  @override
  final String wireName = 'CreatePostDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, CreatePostDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatePostDtoTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatePostDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatePostDtoVisibilityEnumSerializer
    implements PrimitiveSerializer<CreatePostDtoVisibilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EVERY_ONE': 'EVERY_ONE',
    'FOLLOWERS': 'FOLLOWERS',
    'MENTIONED': 'MENTIONED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EVERY_ONE': 'EVERY_ONE',
    'FOLLOWERS': 'FOLLOWERS',
    'MENTIONED': 'MENTIONED',
  };

  @override
  final Iterable<Type> types = const <Type>[CreatePostDtoVisibilityEnum];
  @override
  final String wireName = 'CreatePostDtoVisibilityEnum';

  @override
  Object serialize(Serializers serializers, CreatePostDtoVisibilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatePostDtoVisibilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatePostDtoVisibilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatePostDto extends CreatePostDto {
  @override
  final String content;
  @override
  final CreatePostDtoTypeEnum type;
  @override
  final num? parentId;
  @override
  final CreatePostDtoVisibilityEnum visibility;

  factory _$CreatePostDto([void Function(CreatePostDtoBuilder)? updates]) =>
      (CreatePostDtoBuilder()..update(updates))._build();

  _$CreatePostDto._(
      {required this.content,
      required this.type,
      this.parentId,
      required this.visibility})
      : super._();
  @override
  CreatePostDto rebuild(void Function(CreatePostDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatePostDtoBuilder toBuilder() => CreatePostDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatePostDto &&
        content == other.content &&
        type == other.type &&
        parentId == other.parentId &&
        visibility == other.visibility;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatePostDto')
          ..add('content', content)
          ..add('type', type)
          ..add('parentId', parentId)
          ..add('visibility', visibility))
        .toString();
  }
}

class CreatePostDtoBuilder
    implements Builder<CreatePostDto, CreatePostDtoBuilder> {
  _$CreatePostDto? _$v;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  CreatePostDtoTypeEnum? _type;
  CreatePostDtoTypeEnum? get type => _$this._type;
  set type(CreatePostDtoTypeEnum? type) => _$this._type = type;

  num? _parentId;
  num? get parentId => _$this._parentId;
  set parentId(num? parentId) => _$this._parentId = parentId;

  CreatePostDtoVisibilityEnum? _visibility;
  CreatePostDtoVisibilityEnum? get visibility => _$this._visibility;
  set visibility(CreatePostDtoVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  CreatePostDtoBuilder() {
    CreatePostDto._defaults(this);
  }

  CreatePostDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _content = $v.content;
      _type = $v.type;
      _parentId = $v.parentId;
      _visibility = $v.visibility;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatePostDto other) {
    _$v = other as _$CreatePostDto;
  }

  @override
  void update(void Function(CreatePostDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatePostDto build() => _build();

  _$CreatePostDto _build() {
    final _$result = _$v ??
        _$CreatePostDto._(
          content: BuiltValueNullFieldError.checkNotNull(
              content, r'CreatePostDto', 'content'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CreatePostDto', 'type'),
          parentId: parentId,
          visibility: BuiltValueNullFieldError.checkNotNull(
              visibility, r'CreatePostDto', 'visibility'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
