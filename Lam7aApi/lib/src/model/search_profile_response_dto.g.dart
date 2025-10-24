// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_profile_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchProfileResponseDto extends SearchProfileResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final BuiltList<ProfileResponseDto> data;
  @override
  final PaginationMetadata metadata;

  factory _$SearchProfileResponseDto(
          [void Function(SearchProfileResponseDtoBuilder)? updates]) =>
      (SearchProfileResponseDtoBuilder()..update(updates))._build();

  _$SearchProfileResponseDto._(
      {required this.status,
      required this.message,
      required this.data,
      required this.metadata})
      : super._();
  @override
  SearchProfileResponseDto rebuild(
          void Function(SearchProfileResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchProfileResponseDtoBuilder toBuilder() =>
      SearchProfileResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchProfileResponseDto &&
        status == other.status &&
        message == other.message &&
        data == other.data &&
        metadata == other.metadata;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchProfileResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data)
          ..add('metadata', metadata))
        .toString();
  }
}

class SearchProfileResponseDtoBuilder
    implements
        Builder<SearchProfileResponseDto, SearchProfileResponseDtoBuilder> {
  _$SearchProfileResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ListBuilder<ProfileResponseDto>? _data;
  ListBuilder<ProfileResponseDto> get data =>
      _$this._data ??= ListBuilder<ProfileResponseDto>();
  set data(ListBuilder<ProfileResponseDto>? data) => _$this._data = data;

  PaginationMetadataBuilder? _metadata;
  PaginationMetadataBuilder get metadata =>
      _$this._metadata ??= PaginationMetadataBuilder();
  set metadata(PaginationMetadataBuilder? metadata) =>
      _$this._metadata = metadata;

  SearchProfileResponseDtoBuilder() {
    SearchProfileResponseDto._defaults(this);
  }

  SearchProfileResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _message = $v.message;
      _data = $v.data.toBuilder();
      _metadata = $v.metadata.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchProfileResponseDto other) {
    _$v = other as _$SearchProfileResponseDto;
  }

  @override
  void update(void Function(SearchProfileResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchProfileResponseDto build() => _build();

  _$SearchProfileResponseDto _build() {
    _$SearchProfileResponseDto _$result;
    try {
      _$result = _$v ??
          _$SearchProfileResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'SearchProfileResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'SearchProfileResponseDto', 'message'),
            data: data.build(),
            metadata: metadata.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'metadata';
        metadata.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchProfileResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
