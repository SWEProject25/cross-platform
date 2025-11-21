import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/search_state.dart';
import '../../viewmodel/search_viewmodel.dart';
import '../../../../../core/models/user_model.dart';

class SearchAutocompleteView extends ConsumerWidget {
  const SearchAutocompleteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(searchViewModelProvider);
    final vm = ref.read(searchViewModelProvider.notifier);
    final state = async.value ?? SearchState();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // -----------------------------------------------------------
        // 🔵 AUTOCOMPLETE SUGGESTIONS
        // -----------------------------------------------------------
        ...state.suggestedAutocompletions!.map(
          (term) => _AutoCompleteTermRow(
            term: term,
            onInsert: () => vm.getAutocompleteTerms(term),
          ),
        ),

        const SizedBox(height: 10),
        const Divider(color: Colors.white24, thickness: 0.3),
        const SizedBox(height: 10),

        // -----------------------------------------------------------
        // 🟣 SUGGESTED USERS
        // -----------------------------------------------------------
        ...state.suggestedUsers!.map(
          (user) => _AutoCompleteUserTile(
            user: user,
            onTap: () =>
                vm.getAutoCompleteUsers(user.name ?? user.username ?? ''),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// AUTOCOMPLETE TERM ROW — Same style as RecentTermRow
// =====================================================================

class _AutoCompleteTermRow extends StatelessWidget {
  final String term;
  final VoidCallback onInsert;

  const _AutoCompleteTermRow({required this.term, required this.onInsert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      color: const Color(0xFF0E0E0E),
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
              angle: -0.8,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// USER TILE FOR AUTOCOMPLETE USERS
// =====================================================================

class _AutoCompleteUserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const _AutoCompleteUserTile({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        color: Colors.black, // full rectangle
        child: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 22,
              backgroundImage: (user.profileImageUrl?.isNotEmpty ?? false)
                  ? NetworkImage(user.profileImageUrl!)
                  : null,
              backgroundColor: Colors.white12,
              child:
                  (user.profileImageUrl == null ||
                      user.profileImageUrl!.isEmpty)
                  ? const Icon(Icons.person, color: Colors.white30)
                  : null,
            ),
            const SizedBox(width: 12),

            // Name + Handle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? user.username ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "@${user.username}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
