// lib/features/search/views/recent_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/search_state.dart';
import '../../viewmodel/search_viewmodel.dart';
import '../../../../../core/models/user_model.dart';

class RecentView extends ConsumerWidget {
  const RecentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(searchViewModelProvider);
    final vm = ref.read(searchViewModelProvider.notifier);
    final state = async.value ?? SearchState();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          "Recent",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 15),

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
                onTap: () => vm.selectRecentProfile(user),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        ...state.recentSearchedTerms!.map(
          (term) => _RecentTermRow(
            term: term,
            onInsert: () => vm.selectRecentTerm(term),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
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
  const _RecentTermRow({required this.term, required this.onInsert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      color: const Color(0xFF0E0E0E), // No border radius
      child: Row(
        children: [
          Expanded(
            child: Text(
              term,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          IconButton(
            onPressed: onInsert,
            icon: Transform.rotate(
              angle: -0.8, // top-left arrow
              child: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
