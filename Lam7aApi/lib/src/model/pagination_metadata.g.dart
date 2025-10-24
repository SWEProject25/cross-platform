// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_metadata.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginationMetadata extends PaginationMetadata {
  @override
  final num total;
  @override
  final num page;
  @override
  final num limit;
  @override
  final num totalPages;

  factory _$PaginationMetadata(
          [void Function(PaginationMetadataBuilder)? updates]) =>
      (PaginationMetadataBuilder()..update(updates))._build();

  _$PaginationMetadata._(
      {required this.total,
      required this.page,
      required this.limit,
      required this.totalPages})
      : super._();
  @override
  PaginationMetadata rebuild(
          void Function(PaginationMetadataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaginationMetadataBuilder toBuilder() =>
      PaginationMetadataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginationMetadata &&
        total == other.total &&
        page == other.page &&
        limit == other.limit &&
        totalPages == other.totalPages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, totalPages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaginationMetadata')
          ..add('total', total)
          ..add('page', page)
          ..add('limit', limit)
          ..add('totalPages', totalPages))
        .toString();
  }
}

class PaginationMetadataBuilder
    implements Builder<PaginationMetadata, PaginationMetadataBuilder> {
  _$PaginationMetadata? _$v;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _limit;
  num? get limit => _$this._limit;
  set limit(num? limit) => _$this._limit = limit;

  num? _totalPages;
  num? get totalPages => _$this._totalPages;
  set totalPages(num? totalPages) => _$this._totalPages = totalPages;

  PaginationMetadataBuilder() {
    PaginationMetadata._defaults(this);
  }

  PaginationMetadataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _page = $v.page;
      _limit = $v.limit;
      _totalPages = $v.totalPages;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaginationMetadata other) {
    _$v = other as _$PaginationMetadata;
  }

  @override
  void update(void Function(PaginationMetadataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginationMetadata build() => _build();

  _$PaginationMetadata _build() {
    final _$result = _$v ??
        _$PaginationMetadata._(
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'PaginationMetadata', 'total'),
          page: BuiltValueNullFieldError.checkNotNull(
              page, r'PaginationMetadata', 'page'),
          limit: BuiltValueNullFieldError.checkNotNull(
              limit, r'PaginationMetadata', 'limit'),
          totalPages: BuiltValueNullFieldError.checkNotNull(
              totalPages, r'PaginationMetadata', 'totalPages'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
