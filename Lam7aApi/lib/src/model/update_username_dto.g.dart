// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_username_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateUsernameDto extends UpdateUsernameDto {
  @override
  final String username;

  factory _$UpdateUsernameDto(
          [void Function(UpdateUsernameDtoBuilder)? updates]) =>
      (UpdateUsernameDtoBuilder()..update(updates))._build();

  _$UpdateUsernameDto._({required this.username}) : super._();
  @override
  UpdateUsernameDto rebuild(void Function(UpdateUsernameDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateUsernameDtoBuilder toBuilder() =>
      UpdateUsernameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateUsernameDto && username == other.username;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateUsernameDto')
          ..add('username', username))
        .toString();
  }
}

class UpdateUsernameDtoBuilder
    implements Builder<UpdateUsernameDto, UpdateUsernameDtoBuilder> {
  _$UpdateUsernameDto? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  UpdateUsernameDtoBuilder() {
    UpdateUsernameDto._defaults(this);
  }

  UpdateUsernameDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateUsernameDto other) {
    _$v = other as _$UpdateUsernameDto;
  }

  @override
  void update(void Function(UpdateUsernameDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateUsernameDto build() => _build();

  _$UpdateUsernameDto _build() {
    final _$result = _$v ??
        _$UpdateUsernameDto._(
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'UpdateUsernameDto', 'username'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
