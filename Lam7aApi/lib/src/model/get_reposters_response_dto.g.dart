// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reposters_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetRepostersResponseDto extends GetRepostersResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final BuiltList<RepostUserDto> data;

  factory _$GetRepostersResponseDto(
          [void Function(GetRepostersResponseDtoBuilder)? updates]) =>
      (GetRepostersResponseDtoBuilder()..update(updates))._build();

  _$GetRepostersResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  GetRepostersResponseDto rebuild(
          void Function(GetRepostersResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetRepostersResponseDtoBuilder toBuilder() =>
      GetRepostersResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetRepostersResponseDto &&
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
    return (newBuiltValueToStringHelper(r'GetRepostersResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class GetRepostersResponseDtoBuilder
    implements
        Builder<GetRepostersResponseDto, GetRepostersResponseDtoBuilder> {
  _$GetRepostersResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ListBuilder<RepostUserDto>? _data;
  ListBuilder<RepostUserDto> get data =>
      _$this._data ??= ListBuilder<RepostUserDto>();
  set data(ListBuilder<RepostUserDto>? data) => _$this._data = data;

  GetRepostersResponseDtoBuilder() {
    GetRepostersResponseDto._defaults(this);
  }

  GetRepostersResponseDtoBuilder get _$this {
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
  void replace(GetRepostersResponseDto other) {
    _$v = other as _$GetRepostersResponseDto;
  }

  @override
  void update(void Function(GetRepostersResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetRepostersResponseDto build() => _build();

  _$GetRepostersResponseDto _build() {
    _$GetRepostersResponseDto _$result;
    try {
      _$result = _$v ??
          _$GetRepostersResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GetRepostersResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'GetRepostersResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetRepostersResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
