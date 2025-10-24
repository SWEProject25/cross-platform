// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_repost_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ToggleRepostResponseDto extends ToggleRepostResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final JsonObject data;

  factory _$ToggleRepostResponseDto(
          [void Function(ToggleRepostResponseDtoBuilder)? updates]) =>
      (ToggleRepostResponseDtoBuilder()..update(updates))._build();

  _$ToggleRepostResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  ToggleRepostResponseDto rebuild(
          void Function(ToggleRepostResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ToggleRepostResponseDtoBuilder toBuilder() =>
      ToggleRepostResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ToggleRepostResponseDto &&
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
    return (newBuiltValueToStringHelper(r'ToggleRepostResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class ToggleRepostResponseDtoBuilder
    implements
        Builder<ToggleRepostResponseDto, ToggleRepostResponseDtoBuilder> {
  _$ToggleRepostResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  ToggleRepostResponseDtoBuilder() {
    ToggleRepostResponseDto._defaults(this);
  }

  ToggleRepostResponseDtoBuilder get _$this {
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
  void replace(ToggleRepostResponseDto other) {
    _$v = other as _$ToggleRepostResponseDto;
  }

  @override
  void update(void Function(ToggleRepostResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ToggleRepostResponseDto build() => _build();

  _$ToggleRepostResponseDto _build() {
    final _$result = _$v ??
        _$ToggleRepostResponseDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ToggleRepostResponseDto', 'status'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'ToggleRepostResponseDto', 'message'),
          data: BuiltValueNullFieldError.checkNotNull(
              data, r'ToggleRepostResponseDto', 'data'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
