// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_likers_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetLikersResponseDto extends GetLikersResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final BuiltList<UserDto> data;

  factory _$GetLikersResponseDto(
          [void Function(GetLikersResponseDtoBuilder)? updates]) =>
      (GetLikersResponseDtoBuilder()..update(updates))._build();

  _$GetLikersResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  GetLikersResponseDto rebuild(
          void Function(GetLikersResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetLikersResponseDtoBuilder toBuilder() =>
      GetLikersResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetLikersResponseDto &&
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
    return (newBuiltValueToStringHelper(r'GetLikersResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class GetLikersResponseDtoBuilder
    implements Builder<GetLikersResponseDto, GetLikersResponseDtoBuilder> {
  _$GetLikersResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ListBuilder<UserDto>? _data;
  ListBuilder<UserDto> get data => _$this._data ??= ListBuilder<UserDto>();
  set data(ListBuilder<UserDto>? data) => _$this._data = data;

  GetLikersResponseDtoBuilder() {
    GetLikersResponseDto._defaults(this);
  }

  GetLikersResponseDtoBuilder get _$this {
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
  void replace(GetLikersResponseDto other) {
    _$v = other as _$GetLikersResponseDto;
  }

  @override
  void update(void Function(GetLikersResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetLikersResponseDto build() => _build();

  _$GetLikersResponseDto _build() {
    _$GetLikersResponseDto _$result;
    try {
      _$result = _$v ??
          _$GetLikersResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GetLikersResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'GetLikersResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetLikersResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
