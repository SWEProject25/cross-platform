import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/explore_viewmodel.dart';
import '../../../../common/widgets/user_tile.dart';

class ConnectView extends ConsumerStatefulWidget {
  const ConnectView({super.key});

  @override
  ConsumerState<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends ConsumerState<ConnectView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(exploreViewModelProvider.notifier).loadSuggestedUsers();
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
          'Connect',
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

      // 🔥 Everything scrolls together
      body: ListView(
        padding: const EdgeInsets.all(6),
        children: [
          const SizedBox(height: 8),

          // "Suggested for you" becomes scrollable
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Suggested for you",
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF0D0D0D)
                    : const Color(0xFFFFFFFF),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Loading state
          if (state.value!.isSuggestedUsersLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

          // List of users
          ...state.value!.suggestedUsersFull.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: UserTile(user: user),
            ),
          ),
        ],
      ),
    );
  }
}
