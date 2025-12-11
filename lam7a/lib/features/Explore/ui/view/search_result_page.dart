import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/search_appbar.dart';

import '../viewmodel/search_results_viewmodel.dart';
import '../state/search_result_state.dart';
import 'search_result/toptab.dart';
import 'search_result/latesttab.dart';
import 'search_result/peopletab.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  const SearchResultPage({super.key, required this.hintText});
  final String hintText;

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final tabs = ["Top", "Latest", "People"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

    // 🔵 Correct tab change listener:
    // Fires only when tab is fully changed
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final vm = ref.read(searchResultsViewModelProvider.notifier);
      vm.selectTab(CurrentResultType.values[_tabController.index]);
    });

    // initial search
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchResultsViewModelProvider.notifier).search(widget.hintText);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchResultsViewModelProvider);
    final vm = ref.read(searchResultsViewModelProvider.notifier);

    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: SearchAppbar(width: width, hintText: widget.hintText),
      body: state.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: theme.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),

        error: (e, st) => Center(
          child: Text("Error: $e", style: const TextStyle(color: Colors.red)),
        ),

        data: (data) {
          // Sync controller with state-selected tab
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_tabController.index != data.currentResultType.index &&
                !_tabController.indexIsChanging) {
              _tabController.animateTo(data.currentResultType.index);
            }
          });

          return Column(
            children: [
              _buildTabBar(theme),

              const Divider(color: Colors.white12, height: 1),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TopTab(data: data, vm: vm),
                    LatestTab(data: data, vm: vm),
                    PeopleTab(data: data, vm: vm),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF1d9bf0),
        indicatorWeight: 3,
        labelPadding: const EdgeInsets.only(right: 28),

        labelColor: theme.brightness == Brightness.light
            ? const Color(0xFF0f1418)
            : const Color(0xFFd9d9d9),

        unselectedLabelColor: theme.brightness == Brightness.light
            ? const Color(0xFF526470)
            : const Color(0xFF7c838b),

        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),

        dividerColor: theme.brightness == Brightness.light
            ? const Color(0xFFE5E5E5)
            : const Color(0xFF2A2A2A),
        dividerHeight: 0.3,

        tabs: const [
          Tab(text: "Top"),
          Tab(text: "Latest"),
          Tab(text: "People"),
        ],
      ),
    );
  }
}
