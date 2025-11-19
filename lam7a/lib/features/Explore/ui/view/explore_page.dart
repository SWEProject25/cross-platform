import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/explore_state.dart';
import '../widgets/tab_button.dart';
import 'search_page.dart';
import '../viewmodel/explore_viewmodel.dart';
import 'for_you_view.dart';
import 'trending_view.dart';

class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreViewModelProvider);
    final vm = ref.read(exploreViewModelProvider.notifier);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaler;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context, width, textScale),

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

AppBar _buildAppBar(BuildContext context, double width, TextScaler textScale) {
  return AppBar(
    backgroundColor: Colors.black,
    elevation: 0,
    titleSpacing: 0,
    title: Row(
      children: [
        IconButton(
          iconSize: width * 0.06,
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),

        SizedBox(width: width * 0.04),

        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecentView()),
              );
            },
            child: Container(
              height: 38.0,
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                color: Color(0xFF202328),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Search X",
                style: TextStyle(color: Colors.white54, fontSize: 15),
              ),
            ),
          ),
        ),

        SizedBox(width: width * 0.04),

        IconButton(
          padding: EdgeInsets.only(top: 4),
          iconSize: width * 0.06,
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    ),
  );
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
