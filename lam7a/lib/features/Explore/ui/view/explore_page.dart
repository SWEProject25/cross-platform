import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/explore_state.dart';
import '../widgets/tab_button.dart';
import 'search_and_auto_complete/recent_searchs_view.dart';
import '../viewmodel/explore_viewmodel.dart';
import 'for_you_view.dart';
import 'trending_view.dart';
import '../widgets/search_appbar.dart';

class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreViewModelProvider);
    final vm = ref.read(exploreViewModelProvider.notifier);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: SearchAppbar(width: width, hintText: "Search X"),

      body: state.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, st) => Center(
          child: Text("Error: $err", style: const TextStyle(color: Colors.red)),
        ),
        data: (data) {
          return Column(
            children: [
              _tabs(vm, data.selectedPage, width),
              const Divider(height: 1, color: Color(0x20FFFFFF)),

              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  onRefresh: () async {
                    if (data.selectedPage == ExplorePageView.forYou) {
                      await Future.wait([
                        vm.refreshHashtags(),
                        vm.refreshUsers(),
                      ]);
                    } else {
                      await vm.refreshHashtags();
                    }
                  },

                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: data.selectedPage == ExplorePageView.forYou
                        ? ForYouView(
                            trendingHashtags: data.trendingHashtags!,
                            suggestedUsers: data.suggestedUsers!,
                            key: const ValueKey("foryou"),
                          )
                        : TrendingView(
                            trendingHashtags: data.trendingHashtags!,
                            key: const ValueKey("trending"),
                          ),
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

Widget _tabs(ExploreViewModel vm, ExplorePageView selected, double width) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Row(
          children: [
            Expanded(
              child: TabButton(
                label: "For You",
                selected: selected == ExplorePageView.forYou,
                onTap: () => vm.selectTap(ExplorePageView.forYou),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: TabButton(
                label: "Trending",
                selected: selected == ExplorePageView.trending,
                onTap: () => vm.selectTap(ExplorePageView.trending),
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
              alignment: selected == ExplorePageView.forYou
                  ? Alignment(-0.56, 0)
                  : Alignment(0.57, 0),
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
