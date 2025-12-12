import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/explore_viewmodel.dart';
import '../../../../common/widgets/static_tweets_list.dart';

class InterestView extends ConsumerStatefulWidget {
  const InterestView({super.key, required this.interest});

  final String interest;

  @override
  ConsumerState<InterestView> createState() => _InterestViewState();
}

class _InterestViewState extends ConsumerState<InterestView> {
  late final String interest;
  @override
  void initState() {
    super.initState();

    interest = widget.interest;

    Future.microtask(() {
      ref.read(exploreViewModelProvider.notifier).loadIntresesTweets(interest);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(exploreViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        title: Text(
          interest,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.brightness == Brightness.light
                ? theme.appBarTheme.titleTextStyle!.color
                : const Color(0xFFE7E9EA),
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 0.3,
            thickness: 0.3,
            color: theme.brightness == Brightness.light
                ? const Color.fromARGB(120, 83, 99, 110)
                : const Color(0xFF8B98A5),
          ),
        ),
      ),

      body: Builder(
        builder: (_) {
          final data = state.value!;

          if (data.isIntrestTweetsLoading && data.intrestTweets.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF1D9BF0)
                    : Colors.white,
              ),
            );
          }

          return StaticTweetsListView(
            tweets: data.intrestTweets,
            selfScrolling: true,
          );
        },
      ),
    );
  }
}
