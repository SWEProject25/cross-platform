// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PostResponseDtoTypeEnum _$postResponseDtoTypeEnum_POST =
    const PostResponseDtoTypeEnum._('POST');
const PostResponseDtoTypeEnum _$postResponseDtoTypeEnum_REPLY =
    const PostResponseDtoTypeEnum._('REPLY');
const PostResponseDtoTypeEnum _$postResponseDtoTypeEnum_QUOTE =
    const PostResponseDtoTypeEnum._('QUOTE');

PostResponseDtoTypeEnum _$postResponseDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'POST':
      return _$postResponseDtoTypeEnum_POST;
    case 'REPLY':
      return _$postResponseDtoTypeEnum_REPLY;
    case 'QUOTE':
      return _$postResponseDtoTypeEnum_QUOTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PostResponseDtoTypeEnum> _$postResponseDtoTypeEnumValues =
    BuiltSet<PostResponseDtoTypeEnum>(const <PostResponseDtoTypeEnum>[
  _$postResponseDtoTypeEnum_POST,
  _$postResponseDtoTypeEnum_REPLY,
  _$postResponseDtoTypeEnum_QUOTE,
]);

const PostResponseDtoVisibilityEnum _$postResponseDtoVisibilityEnum_EVERY_ONE =
    const PostResponseDtoVisibilityEnum._('EVERY_ONE');
const PostResponseDtoVisibilityEnum _$postResponseDtoVisibilityEnum_FOLLOWERS =
    const PostResponseDtoVisibilityEnum._('FOLLOWERS');
const PostResponseDtoVisibilityEnum _$postResponseDtoVisibilityEnum_MENTIONED =
    const PostResponseDtoVisibilityEnum._('MENTIONED');

PostResponseDtoVisibilityEnum _$postResponseDtoVisibilityEnumValueOf(
    String name) {
  switch (name) {
    case 'EVERY_ONE':
      return _$postResponseDtoVisibilityEnum_EVERY_ONE;
    case 'FOLLOWERS':
      return _$postResponseDtoVisibilityEnum_FOLLOWERS;
    case 'MENTIONED':
      return _$postResponseDtoVisibilityEnum_MENTIONED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PostResponseDtoVisibilityEnum>
    _$postResponseDtoVisibilityEnumValues = BuiltSet<
        PostResponseDtoVisibilityEnum>(const <PostResponseDtoVisibilityEnum>[
  _$postResponseDtoVisibilityEnum_EVERY_ONE,
  _$postResponseDtoVisibilityEnum_FOLLOWERS,
  _$postResponseDtoVisibilityEnum_MENTIONED,
]);

Serializer<PostResponseDtoTypeEnum> _$postResponseDtoTypeEnumSerializer =
    _$PostResponseDtoTypeEnumSerializer();
Serializer<PostResponseDtoVisibilityEnum>
    _$postResponseDtoVisibilityEnumSerializer =
    _$PostResponseDtoVisibilityEnumSerializer();

class _$PostResponseDtoTypeEnumSerializer
    implements PrimitiveSerializer<PostResponseDtoTypeEnum> {
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
  final Iterable<Type> types = const <Type>[PostResponseDtoTypeEnum];
  @override
  final String wireName = 'PostResponseDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, PostResponseDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PostResponseDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PostResponseDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PostResponseDtoVisibilityEnumSerializer
    implements PrimitiveSerializer<PostResponseDtoVisibilityEnum> {
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
  final Iterable<Type> types = const <Type>[PostResponseDtoVisibilityEnum];
  @override
  final String wireName = 'PostResponseDtoVisibilityEnum';

  @override
  Object serialize(
          Serializers serializers, PostResponseDtoVisibilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PostResponseDtoVisibilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PostResponseDtoVisibilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PostResponseDto extends PostResponseDto {
  @override
  final num id;
  @override
  final num userId;
  @override
  final String content;
  @override
  final PostResponseDtoTypeEnum type;
  @override
  final JsonObject? parentId;
  @override
  final PostResponseDtoVisibilityEnum visibility;
  @override
  final DateTime createdAt;

  factory _$PostResponseDto([void Function(PostResponseDtoBuilder)? updates]) =>
      (PostResponseDtoBuilder()..update(updates))._build();

  _$PostResponseDto._(
      {required this.id,
      required this.userId,
      required this.content,
      required this.type,
      this.parentId,
      required this.visibility,
      required this.createdAt})
      : super._();
  @override
  PostResponseDto rebuild(void Function(PostResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostResponseDtoBuilder toBuilder() => PostResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostResponseDto &&
        id == other.id &&
        userId == other.userId &&
        content == other.content &&
        type == other.type &&
        parentId == other.parentId &&
        visibility == other.visibility &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PostResponseDto')
          ..add('id', id)
          ..add('userId', userId)
          ..add('content', content)
          ..add('type', type)
          ..add('parentId', parentId)
          ..add('visibility', visibility)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PostResponseDtoBuilder
    implements Builder<PostResponseDto, PostResponseDtoBuilder> {
  _$PostResponseDto? _$v;

  num? _id;
  num? get id => _$this._id;
  set id(num? id) => _$this._id = id;

  num? _userId;
  num? get userId => _$this._userId;
  set userId(num? userId) => _$this._userId = userId;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  PostResponseDtoTypeEnum? _type;
  PostResponseDtoTypeEnum? get type => _$this._type;
  set type(PostResponseDtoTypeEnum? type) => _$this._type = type;

  JsonObject? _parentId;
  JsonObject? get parentId => _$this._parentId;
  set parentId(JsonObject? parentId) => _$this._parentId = parentId;

  PostResponseDtoVisibilityEnum? _visibility;
  PostResponseDtoVisibilityEnum? get visibility => _$this._visibility;
  set visibility(PostResponseDtoVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PostResponseDtoBuilder() {
    PostResponseDto._defaults(this);
  }

  PostResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _content = $v.content;
      _type = $v.type;
      _parentId = $v.parentId;
      _visibility = $v.visibility;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostResponseDto other) {
    _$v = other as _$PostResponseDto;
  }

  @override
  void update(void Function(PostResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostResponseDto build() => _build();

  _$PostResponseDto _build() {
    final _$result = _$v ??
        _$PostResponseDto._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PostResponseDto', 'id'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'PostResponseDto', 'userId'),
          content: BuiltValueNullFieldError.checkNotNull(
              content, r'PostResponseDto', 'content'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'PostResponseDto', 'type'),
          parentId: parentId,
          visibility: BuiltValueNullFieldError.checkNotNull(
              visibility, r'PostResponseDto', 'visibility'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'PostResponseDto', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
