// lib/features/search/views/recent_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/search_viewmodel.dart';
import '../../../../../core/models/user_model.dart';
import 'package:lam7a/features/profile/ui/view/profile_screen.dart';

class RecentView extends ConsumerWidget {
  const RecentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(searchViewModelProvider);

    if (async.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (async.hasError) {
      return const Center(child: Text("Error loading recent data"));
    }

    final vm = ref.read(searchViewModelProvider.notifier);
    final state = async.value!;

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        const Text(
          "Recent",
          style: TextStyle(
            color: Color.fromARGB(155, 187, 186, 186),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),

        // -------------------- USERS ---------------------
        if (state.recentSearchedUsers!.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.recentSearchedUsers!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
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
        width: 90,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: (p.profileImageUrl?.isNotEmpty ?? false)
                  ? NetworkImage(p.profileImageUrl!)
                  : null,
              backgroundColor: Colors.white12,
              child: (p.profileImageUrl == null || p.profileImageUrl!.isEmpty)
                  ? const Icon(Icons.person, color: Colors.white30)
                  : null,
            ),
            const SizedBox(height: 8),

            // Username
            Text(
              p.name ?? p.username ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),

            // Handle
            Text(
              "@${p.username ?? ''}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
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
      padding: const EdgeInsets.only(left: 4),
      color: theme.scaffoldBackgroundColor, // No border radius
      child: Row(
        children: [
          Expanded(
            child: Text(
              term,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: onInsert,
            icon: Image.asset(
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
