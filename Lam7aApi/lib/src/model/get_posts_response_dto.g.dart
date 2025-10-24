// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_posts_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetPostsResponseDto extends GetPostsResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final BuiltList<PostResponseDto> data;

  factory _$GetPostsResponseDto(
          [void Function(GetPostsResponseDtoBuilder)? updates]) =>
      (GetPostsResponseDtoBuilder()..update(updates))._build();

  _$GetPostsResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  GetPostsResponseDto rebuild(
          void Function(GetPostsResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetPostsResponseDtoBuilder toBuilder() =>
      GetPostsResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetPostsResponseDto &&
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
    return (newBuiltValueToStringHelper(r'GetPostsResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class GetPostsResponseDtoBuilder
    implements Builder<GetPostsResponseDto, GetPostsResponseDtoBuilder> {
  _$GetPostsResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ListBuilder<PostResponseDto>? _data;
  ListBuilder<PostResponseDto> get data =>
      _$this._data ??= ListBuilder<PostResponseDto>();
  set data(ListBuilder<PostResponseDto>? data) => _$this._data = data;

  GetPostsResponseDtoBuilder() {
    GetPostsResponseDto._defaults(this);
  }

  GetPostsResponseDtoBuilder get _$this {
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
  void replace(GetPostsResponseDto other) {
    _$v = other as _$GetPostsResponseDto;
  }

  @override
  void update(void Function(GetPostsResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetPostsResponseDto build() => _build();

  _$GetPostsResponseDto _build() {
    _$GetPostsResponseDto _$result;
    try {
      _$result = _$v ??
          _$GetPostsResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GetPostsResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'GetPostsResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetPostsResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
