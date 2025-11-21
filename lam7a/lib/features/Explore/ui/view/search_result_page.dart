import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/explore_state.dart';
import '../widgets/tab_button.dart';
import 'search_and_auto_complete/recent_searchs_view.dart';
import '../viewmodel/search_results_viewmodel.dart';
import '../widgets/search_appbar.dart';
import '../state/search_result_state.dart';

class SearchResultPage extends ConsumerWidget {
  const SearchResultPage({super.key, required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchResultsViewmodelProvider);
    final vm = ref.read(searchResultsViewmodelProvider.notifier);

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: SearchAppbar(width: width, hintText: hintText),

      body: state.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, st) => Center(
          child: Text("Error: $err", style: const TextStyle(color: Colors.red)),
        ),
        data: (data) {
          return Column(
            children: [
              _tabs(vm, data.currentResultType, width),
              const Divider(height: 1, color: Color(0x20FFFFFF)),

              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  onRefresh: () async {}, //TODO: implement refresh logic

                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: switch (data.currentResultType) {
                      CurrentResultType.top => SizedBox(height: 30),
                      CurrentResultType.latest => SizedBox(height: 30),
                      CurrentResultType.people => SizedBox(height: 30),
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _tabs(
  SearchResultsViewmodel vm,
  CurrentResultType selected,
  double width,
) {
  Alignment getAlignment(CurrentResultType selected) {
    switch (selected) {
      case CurrentResultType.top:
        return const Alignment(-0.80, 0); // Far left
      case CurrentResultType.latest:
        return const Alignment(0.0, 0); // Center
      case CurrentResultType.people:
        return const Alignment(0.80, 0); // Far right
    }
  }

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Row(
          children: [
            Expanded(
              child: TabButton(
                label: "Top",
                selected: selected == ExplorePageView.forYou,
                onTap: () => vm.selectTab(CurrentResultType.top),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: TabButton(
                label: "Latest",
                selected: selected == ExplorePageView.trending,
                onTap: () => vm.selectTab(CurrentResultType.latest),
              ),
            ),
            Expanded(
              child: TabButton(
                label: "People",
                selected: selected == ExplorePageView.trending,
                onTap: () => vm.selectTab(CurrentResultType.people),
              ),
            ),
          ],
        ),
      ),

      // ===== INDICATOR (blue sliding bar) ===== //
      SizedBox(
        height: 3,
        child: Stack(
          children: [
            // background transparent line (sits above divider)
            Container(color: Colors.transparent),

            // blue sliding indicator
            AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOutSine,
              alignment: getAlignment(selected),

              child: Container(
                width: width * 0.15,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // full round pill shape
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
