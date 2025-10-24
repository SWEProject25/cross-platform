// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ErrorResponseDtoStatusEnum _$errorResponseDtoStatusEnum_error =
    const ErrorResponseDtoStatusEnum._('error');
const ErrorResponseDtoStatusEnum _$errorResponseDtoStatusEnum_fail =
    const ErrorResponseDtoStatusEnum._('fail');

ErrorResponseDtoStatusEnum _$errorResponseDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'error':
      return _$errorResponseDtoStatusEnum_error;
    case 'fail':
      return _$errorResponseDtoStatusEnum_fail;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ErrorResponseDtoStatusEnum> _$errorResponseDtoStatusEnumValues =
    BuiltSet<ErrorResponseDtoStatusEnum>(const <ErrorResponseDtoStatusEnum>[
  _$errorResponseDtoStatusEnum_error,
  _$errorResponseDtoStatusEnum_fail,
]);

Serializer<ErrorResponseDtoStatusEnum> _$errorResponseDtoStatusEnumSerializer =
    _$ErrorResponseDtoStatusEnumSerializer();

class _$ErrorResponseDtoStatusEnumSerializer
    implements PrimitiveSerializer<ErrorResponseDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'error': 'error',
    'fail': 'fail',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'error': 'error',
    'fail': 'fail',
  };

  @override
  final Iterable<Type> types = const <Type>[ErrorResponseDtoStatusEnum];
  @override
  final String wireName = 'ErrorResponseDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, ErrorResponseDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ErrorResponseDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ErrorResponseDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ErrorResponseDto extends ErrorResponseDto {
  @override
  final ErrorResponseDtoStatusEnum status;
  @override
  final String message;
  @override
  final JsonObject? error;

  factory _$ErrorResponseDto(
          [void Function(ErrorResponseDtoBuilder)? updates]) =>
      (ErrorResponseDtoBuilder()..update(updates))._build();

  _$ErrorResponseDto._(
      {required this.status, required this.message, this.error})
      : super._();
  @override
  ErrorResponseDto rebuild(void Function(ErrorResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorResponseDtoBuilder toBuilder() =>
      ErrorResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorResponseDto &&
        status == other.status &&
        message == other.message &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('error', error))
        .toString();
  }
}

class ErrorResponseDtoBuilder
    implements Builder<ErrorResponseDto, ErrorResponseDtoBuilder> {
  _$ErrorResponseDto? _$v;

  ErrorResponseDtoStatusEnum? _status;
  ErrorResponseDtoStatusEnum? get status => _$this._status;
  set status(ErrorResponseDtoStatusEnum? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  JsonObject? _error;
  JsonObject? get error => _$this._error;
  set error(JsonObject? error) => _$this._error = error;

  ErrorResponseDtoBuilder() {
    ErrorResponseDto._defaults(this);
  }

  ErrorResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _message = $v.message;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorResponseDto other) {
    _$v = other as _$ErrorResponseDto;
  }

  @override
  void update(void Function(ErrorResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorResponseDto build() => _build();

  _$ErrorResponseDto _build() {
    final _$result = _$v ??
        _$ErrorResponseDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ErrorResponseDto', 'status'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'ErrorResponseDto', 'message'),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
