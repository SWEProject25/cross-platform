// lib/features/search/views/recent_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/search_state.dart';
import '../viewmodel/search_viewmodel.dart';
import '../../../../core/models/user_model.dart';

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
        // Recent profiles header
        const Text(
          'Recent profiles',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),

        // Profiles list (vertical)
        ...state.recentSearchedUsers!.map(
          (p) => _ProfileCard(
            p: p,
            onTap: () {
              vm.selectRecentProfile(p);
            },
          ),
        ),

        const SizedBox(height: 20),
        const Text(
          'Recent search terms',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),

        // Recent search terms with diagonal arrow
        ...state.recentSearchedTerms!.map((term) {
          return _RecentTermRow(
            term: term,
            onInsert: () => vm.selectRecentTerm(term),
          );
        }),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserModel p;
  final VoidCallback onTap;
  const _ProfileCard({required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF111111),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
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
              const SizedBox(width: 12),
              // Name + handle column with restricted width
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with ellipsis
                    Text(
                      p.name ?? p.username ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${p.username ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white24),
            ],
          ),
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E0E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              term,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          // Diagonal arrow button: we can use a rotated icon to appear diagonal
          IconButton(
            onPressed: onInsert,
            icon: Transform.rotate(
              angle: -0.8, // radians to give a diagonal effect
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
