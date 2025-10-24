// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_post_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeletePostResponseDto extends DeletePostResponseDto {
  @override
  final String status;
  @override
  final String message;

  factory _$DeletePostResponseDto(
          [void Function(DeletePostResponseDtoBuilder)? updates]) =>
      (DeletePostResponseDtoBuilder()..update(updates))._build();

  _$DeletePostResponseDto._({required this.status, required this.message})
      : super._();
  @override
  DeletePostResponseDto rebuild(
          void Function(DeletePostResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeletePostResponseDtoBuilder toBuilder() =>
      DeletePostResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeletePostResponseDto &&
        status == other.status &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeletePostResponseDto')
          ..add('status', status)
          ..add('message', message))
        .toString();
  }
}

class DeletePostResponseDtoBuilder
    implements Builder<DeletePostResponseDto, DeletePostResponseDtoBuilder> {
  _$DeletePostResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  DeletePostResponseDtoBuilder() {
    DeletePostResponseDto._defaults(this);
  }

  DeletePostResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeletePostResponseDto other) {
    _$v = other as _$DeletePostResponseDto;
  }

  @override
  void update(void Function(DeletePostResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeletePostResponseDto build() => _build();

  _$DeletePostResponseDto _build() {
    final _$result = _$v ??
        _$DeletePostResponseDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DeletePostResponseDto', 'status'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'DeletePostResponseDto', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
