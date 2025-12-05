import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';

abstract class PaginationNotifier<T> extends Notifier<PaginationState<T>> {
  final int pageSize;
  PaginationNotifier({this.pageSize = 20}) : super();

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newPage = 1;
      final (newItems, hasMore) = await fetchPage(newPage);
      state = state.copyWith(
        items: newItems,
        page: newPage,
        isLoading: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final newPage = 1;
      final (newItems, hasMore) = await fetchPage(newPage);
      state = state.copyWith(
        items: newItems,
        page: newPage,
        isRefreshing: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.isLoading ||
        state.isRefreshing)
      return;
    state = state.copyWith(isLoadingMore: true, error: null);
    try {
      final nextPage = state.page + 1;
      final (newItems, hasMore) = await fetchPage(nextPage);
      state = state.copyWith(
        items: mergeList(state.items, newItems),
        page: nextPage,
        isLoadingMore: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  Future<(List<T> items, bool hasMore)> fetchPage(int page);
  List<T> mergeList(List<T> a, List<T> b) {
    return [...a, ...b];
  }
}