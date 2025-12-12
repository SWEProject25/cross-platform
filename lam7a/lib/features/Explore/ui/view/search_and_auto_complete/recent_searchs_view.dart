// lib/features/search/views/recent_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/search_viewmodel.dart';
import '../../../../../core/models/user_model.dart';
import 'package:lam7a/features/profile/ui/view/profile_screen.dart';
import '../search_result_page.dart';
import '../../viewmodel/search_results_viewmodel.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';

class RecentView extends ConsumerWidget {
  const RecentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(searchViewModelProvider);
    ThemeData theme = Theme.of(context);

    if (async.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (async.hasError) {
      return const Center(child: Text("Error loading recent data"));
    }

    final vm = ref.read(searchViewModelProvider.notifier);
    final state = async.value!;

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        SizedBox(height: 16),
        Row(
          children: [
            SizedBox(width: 17),
            Text(
              "Recent",
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? Color(0xFF51646f)
                    : Color(0xFF7c828a),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // -------------------- USERS ---------------------
        if (state.recentSearchedUsers!.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.recentSearchedUsers!.length,
              separatorBuilder: (_, _) => const SizedBox(width: 0),
              itemBuilder: (context, index) {
                final user = state.recentSearchedUsers![index];
                return _HorizontalUserCard(
                  p: user,
                  onTap: () => () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                        settings: RouteSettings(
                          arguments: {"username": user.username},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

        // -------------------- TERMS ---------------------
        ...state.recentSearchedTerms!.map(
          (term) => _RecentTermRow(
            term: term,
            onInsert: () => vm.insertSearchedTerm(term),
          ),
        ),
      ],
    );
  }
}

class _HorizontalUserCard extends StatelessWidget {
  final UserModel p;
  final VoidCallback onTap;
  const _HorizontalUserCard({required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppUserAvatar(
              radius: 22,
              imageUrl: p.profileImageUrl,
              displayName: p.name,
              username: p.username,
            ),

            const SizedBox(height: 8),

            // Username
            SizedBox(
              width: 120,
              child: Center(
                child: Text(
                  p.name ?? p.username ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.brightness == Brightness.light
                        ? Color(0xFF0f1317)
                        : Color(0xFFd8d8d8),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),

            // Handle
            Text(
              "@${p.username ?? ''}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? Color(0xFF57646e)
                    : Color(0xFF7b7f85),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTermRow extends StatelessWidget {
  final String term;
  final VoidCallback onInsert;
  //final void Function() getResult;
  const _RecentTermRow({required this.term, required this.onInsert});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.only(left: 15),
      color: theme.scaffoldBackgroundColor, // No border radius
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProviderScope(
                      // overrideWith is used to create a fresh SearchResultsViewmodel for this page
                      overrides: [
                        searchResultsViewModelProvider.overrideWith(
                          // create new instance for each pushed page
                          () => SearchResultsViewmodel(),
                        ),
                      ],
                      child: SearchResultPage(hintText: term),
                    ),
                  ),
                );
              },
              child: Text(
                term,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.brightness == Brightness.light
                      ? Color(0xFF0e1317)
                      : Color(0xFFd9d9d9),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onInsert,
            icon: theme.brightness == Brightness.light
                ? Image.asset(
                    'assets/images/top-left-svgrepo-com-light.png',
                    width: 20,
                    height: 20,
                  )
                : Image.asset(
                    'assets/images/top-left-svgrepo-com-dark.png',
                    width: 20,
                    height: 20,
                  ),
          ),
        ],
      ),
    );
  }
}
