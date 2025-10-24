// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_like_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ToggleLikeResponseDto extends ToggleLikeResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final JsonObject data;

  factory _$ToggleLikeResponseDto(
          [void Function(ToggleLikeResponseDtoBuilder)? updates]) =>
      (ToggleLikeResponseDtoBuilder()..update(updates))._build();

  _$ToggleLikeResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  ToggleLikeResponseDto rebuild(
          void Function(ToggleLikeResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ToggleLikeResponseDtoBuilder toBuilder() =>
      ToggleLikeResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ToggleLikeResponseDto &&
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
    return (newBuiltValueToStringHelper(r'ToggleLikeResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class ToggleLikeResponseDtoBuilder
    implements Builder<ToggleLikeResponseDto, ToggleLikeResponseDtoBuilder> {
  _$ToggleLikeResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  ToggleLikeResponseDtoBuilder() {
    ToggleLikeResponseDto._defaults(this);
  }

  ToggleLikeResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _message = $v.message;
      _data = $v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ToggleLikeResponseDto other) {
    _$v = other as _$ToggleLikeResponseDto;
  }

  @override
  void update(void Function(ToggleLikeResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ToggleLikeResponseDto build() => _build();

  _$ToggleLikeResponseDto _build() {
    final _$result = _$v ??
        _$ToggleLikeResponseDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ToggleLikeResponseDto', 'status'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'ToggleLikeResponseDto', 'message'),
          data: BuiltValueNullFieldError.checkNotNull(
              data, r'ToggleLikeResponseDto', 'data'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
