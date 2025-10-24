// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_liked_posts_response_dto_data_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetLikedPostsResponseDtoDataInner
    extends GetLikedPostsResponseDtoDataInner {
  @override
  final num? id;
  @override
  final num? userId;
  @override
  final String? content;
  @override
  final String? type;
  @override
  final num? parentId;
  @override
  final String? visibility;
  @override
  final DateTime? createdAt;

  factory _$GetLikedPostsResponseDtoDataInner(
          [void Function(GetLikedPostsResponseDtoDataInnerBuilder)? updates]) =>
      (GetLikedPostsResponseDtoDataInnerBuilder()..update(updates))._build();

  _$GetLikedPostsResponseDtoDataInner._(
      {this.id,
      this.userId,
      this.content,
      this.type,
      this.parentId,
      this.visibility,
      this.createdAt})
      : super._();
  @override
  GetLikedPostsResponseDtoDataInner rebuild(
          void Function(GetLikedPostsResponseDtoDataInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetLikedPostsResponseDtoDataInnerBuilder toBuilder() =>
      GetLikedPostsResponseDtoDataInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetLikedPostsResponseDtoDataInner &&
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
    return (newBuiltValueToStringHelper(r'GetLikedPostsResponseDtoDataInner')
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

class GetLikedPostsResponseDtoDataInnerBuilder
    implements
        Builder<GetLikedPostsResponseDtoDataInner,
            GetLikedPostsResponseDtoDataInnerBuilder> {
  _$GetLikedPostsResponseDtoDataInner? _$v;

  num? _id;
  num? get id => _$this._id;
  set id(num? id) => _$this._id = id;

  num? _userId;
  num? get userId => _$this._userId;
  set userId(num? userId) => _$this._userId = userId;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  num? _parentId;
  num? get parentId => _$this._parentId;
  set parentId(num? parentId) => _$this._parentId = parentId;

  String? _visibility;
  String? get visibility => _$this._visibility;
  set visibility(String? visibility) => _$this._visibility = visibility;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  GetLikedPostsResponseDtoDataInnerBuilder() {
    GetLikedPostsResponseDtoDataInner._defaults(this);
  }

  GetLikedPostsResponseDtoDataInnerBuilder get _$this {
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
  void replace(GetLikedPostsResponseDtoDataInner other) {
    _$v = other as _$GetLikedPostsResponseDtoDataInner;
  }

  @override
  void update(
      void Function(GetLikedPostsResponseDtoDataInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetLikedPostsResponseDtoDataInner build() => _build();

  _$GetLikedPostsResponseDtoDataInner _build() {
    final _$result = _$v ??
        _$GetLikedPostsResponseDtoDataInner._(
          id: id,
          userId: userId,
          content: content,
          type: type,
          parentId: parentId,
          visibility: visibility,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
