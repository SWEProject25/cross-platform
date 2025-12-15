import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';

class PaginatedListView<T extends PaginationNotifier<K>, K>
    extends ConsumerStatefulWidget {
  final NotifierProvider<T, PaginationState<K>> viewModelProvider;
  final Widget Function(K item) builder;
  final Widget noDataWidget;
  final Widget endOfListWidget;

  const PaginatedListView({
    super.key,
    required this.viewModelProvider,
    required this.builder,
    this.noDataWidget = const Center(child: Text("No Data Available")),
    this.endOfListWidget = const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No more items"),
      ),
    ),
  });

  @override
  ConsumerState<PaginatedListView<T, K>> createState() =>
      _PaginatedListViewState<T, K>();
}

class _PaginatedListViewState<T extends PaginationNotifier<K>, K>
    extends ConsumerState<PaginatedListView<T, K>> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      ref.read(widget.viewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModelProvider);

    return RefreshIndicator(
      onRefresh: () {
        if (state.isLoading || state.isRefreshing) {
          return Future.value();
        }
        return ref.read(widget.viewModelProvider.notifier).refresh();
      },
      child: state.isLoading
          ? Center(child: RefreshProgressIndicator())
          : state.items.isEmpty
          ? CustomScrollView(
              slivers: [SliverFillRemaining(child: widget.noDataWidget)],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemCount: state.items.length + 1,
              itemBuilder: (_, i) {
                if (i == state.items.length) {
                  if (state.isLoadingMore || state.hasMore) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return widget.endOfListWidget;
                }
                return widget.builder(state.items[i]);
              },
            ),
    );
  }
}
