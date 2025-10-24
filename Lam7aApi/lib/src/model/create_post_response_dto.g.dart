// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreatePostResponseDto extends CreatePostResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final PostResponseDto data;

  factory _$CreatePostResponseDto(
          [void Function(CreatePostResponseDtoBuilder)? updates]) =>
      (CreatePostResponseDtoBuilder()..update(updates))._build();

  _$CreatePostResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  CreatePostResponseDto rebuild(
          void Function(CreatePostResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatePostResponseDtoBuilder toBuilder() =>
      CreatePostResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatePostResponseDto &&
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
    return (newBuiltValueToStringHelper(r'CreatePostResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class CreatePostResponseDtoBuilder
    implements Builder<CreatePostResponseDto, CreatePostResponseDtoBuilder> {
  _$CreatePostResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  PostResponseDtoBuilder? _data;
  PostResponseDtoBuilder get data => _$this._data ??= PostResponseDtoBuilder();
  set data(PostResponseDtoBuilder? data) => _$this._data = data;

  CreatePostResponseDtoBuilder() {
    CreatePostResponseDto._defaults(this);
  }

  CreatePostResponseDtoBuilder get _$this {
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
  void replace(CreatePostResponseDto other) {
    _$v = other as _$CreatePostResponseDto;
  }

  @override
  void update(void Function(CreatePostResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatePostResponseDto build() => _build();

  _$CreatePostResponseDto _build() {
    _$CreatePostResponseDto _$result;
    try {
      _$result = _$v ??
          _$CreatePostResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CreatePostResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'CreatePostResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreatePostResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
