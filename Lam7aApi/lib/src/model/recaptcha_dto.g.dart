// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recaptcha_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecaptchaDto extends RecaptchaDto {
  @override
  final String recaptcha;

  factory _$RecaptchaDto([void Function(RecaptchaDtoBuilder)? updates]) =>
      (RecaptchaDtoBuilder()..update(updates))._build();

  _$RecaptchaDto._({required this.recaptcha}) : super._();
  @override
  RecaptchaDto rebuild(void Function(RecaptchaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecaptchaDtoBuilder toBuilder() => RecaptchaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecaptchaDto && recaptcha == other.recaptcha;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recaptcha.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecaptchaDto')
          ..add('recaptcha', recaptcha))
        .toString();
  }
}

class RecaptchaDtoBuilder
    implements Builder<RecaptchaDto, RecaptchaDtoBuilder> {
  _$RecaptchaDto? _$v;

  String? _recaptcha;
  String? get recaptcha => _$this._recaptcha;
  set recaptcha(String? recaptcha) => _$this._recaptcha = recaptcha;

  RecaptchaDtoBuilder() {
    RecaptchaDto._defaults(this);
  }

  RecaptchaDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recaptcha = $v.recaptcha;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecaptchaDto other) {
    _$v = other as _$RecaptchaDto;
  }

  @override
  void update(void Function(RecaptchaDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecaptchaDto build() => _build();

  _$RecaptchaDto _build() {
    final _$result = _$v ??
        _$RecaptchaDto._(
          recaptcha: BuiltValueNullFieldError.checkNotNull(
              recaptcha, r'RecaptchaDto', 'recaptcha'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
