// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_liked_posts_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetLikedPostsResponseDto extends GetLikedPostsResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final BuiltList<GetLikedPostsResponseDtoDataInner> data;

  factory _$GetLikedPostsResponseDto(
          [void Function(GetLikedPostsResponseDtoBuilder)? updates]) =>
      (GetLikedPostsResponseDtoBuilder()..update(updates))._build();

  _$GetLikedPostsResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  GetLikedPostsResponseDto rebuild(
          void Function(GetLikedPostsResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetLikedPostsResponseDtoBuilder toBuilder() =>
      GetLikedPostsResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetLikedPostsResponseDto &&
        status == other.status &&
        message == other.message &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetLikedPostsResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class GetLikedPostsResponseDtoBuilder
    implements
        Builder<GetLikedPostsResponseDto, GetLikedPostsResponseDtoBuilder> {
  _$GetLikedPostsResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ListBuilder<GetLikedPostsResponseDtoDataInner>? _data;
  ListBuilder<GetLikedPostsResponseDtoDataInner> get data =>
      _$this._data ??= ListBuilder<GetLikedPostsResponseDtoDataInner>();
  set data(ListBuilder<GetLikedPostsResponseDtoDataInner>? data) =>
      _$this._data = data;

  GetLikedPostsResponseDtoBuilder() {
    GetLikedPostsResponseDto._defaults(this);
  }

  GetLikedPostsResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _message = $v.message;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetLikedPostsResponseDto other) {
    _$v = other as _$GetLikedPostsResponseDto;
  }

  @override
  void update(void Function(GetLikedPostsResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetLikedPostsResponseDto build() => _build();

  _$GetLikedPostsResponseDto _build() {
    _$GetLikedPostsResponseDto _$result;
    try {
      _$result = _$v ??
          _$GetLikedPostsResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GetLikedPostsResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'GetLikedPostsResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetLikedPostsResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
