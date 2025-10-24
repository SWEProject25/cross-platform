// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiResponseDtoStatusEnum _$apiResponseDtoStatusEnum_success =
    const ApiResponseDtoStatusEnum._('success');
const ApiResponseDtoStatusEnum _$apiResponseDtoStatusEnum_error =
    const ApiResponseDtoStatusEnum._('error');
const ApiResponseDtoStatusEnum _$apiResponseDtoStatusEnum_fail =
    const ApiResponseDtoStatusEnum._('fail');

ApiResponseDtoStatusEnum _$apiResponseDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'success':
      return _$apiResponseDtoStatusEnum_success;
    case 'error':
      return _$apiResponseDtoStatusEnum_error;
    case 'fail':
      return _$apiResponseDtoStatusEnum_fail;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiResponseDtoStatusEnum> _$apiResponseDtoStatusEnumValues =
    BuiltSet<ApiResponseDtoStatusEnum>(const <ApiResponseDtoStatusEnum>[
  _$apiResponseDtoStatusEnum_success,
  _$apiResponseDtoStatusEnum_error,
  _$apiResponseDtoStatusEnum_fail,
]);

Serializer<ApiResponseDtoStatusEnum> _$apiResponseDtoStatusEnumSerializer =
    _$ApiResponseDtoStatusEnumSerializer();

class _$ApiResponseDtoStatusEnumSerializer
    implements PrimitiveSerializer<ApiResponseDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'success': 'success',
    'error': 'error',
    'fail': 'fail',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'success': 'success',
    'error': 'error',
    'fail': 'fail',
  };

  @override
  final Iterable<Type> types = const <Type>[ApiResponseDtoStatusEnum];
  @override
  final String wireName = 'ApiResponseDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, ApiResponseDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiResponseDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiResponseDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiResponseDto extends ApiResponseDto {
  @override
  final ApiResponseDtoStatusEnum status;
  @override
  final String message;
  @override
  final JsonObject? data;

  factory _$ApiResponseDto([void Function(ApiResponseDtoBuilder)? updates]) =>
      (ApiResponseDtoBuilder()..update(updates))._build();

  _$ApiResponseDto._({required this.status, required this.message, this.data})
      : super._();
  @override
  ApiResponseDto rebuild(void Function(ApiResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiResponseDtoBuilder toBuilder() => ApiResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiResponseDto &&
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
    return (newBuiltValueToStringHelper(r'ApiResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class ApiResponseDtoBuilder
    implements Builder<ApiResponseDto, ApiResponseDtoBuilder> {
  _$ApiResponseDto? _$v;

  ApiResponseDtoStatusEnum? _status;
  ApiResponseDtoStatusEnum? get status => _$this._status;
  set status(ApiResponseDtoStatusEnum? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  ApiResponseDtoBuilder() {
    ApiResponseDto._defaults(this);
  }

  ApiResponseDtoBuilder get _$this {
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
  void replace(ApiResponseDto other) {
    _$v = other as _$ApiResponseDto;
  }

  @override
  void update(void Function(ApiResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiResponseDto build() => _build();

  _$ApiResponseDto _build() {
    final _$result = _$v ??
        _$ApiResponseDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ApiResponseDto', 'status'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'ApiResponseDto', 'message'),
          data: data,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
