import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/search_state.dart';
import '../../viewmodel/search_viewmodel.dart';
import '../../../../../core/models/user_model.dart';
import 'package:lam7a/features/profile/ui/view/profile_screen.dart';

class SearchAutocompleteView extends ConsumerWidget {
  const SearchAutocompleteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(searchViewModelProvider);
    final vm = ref.read(searchViewModelProvider.notifier);
    final state = async.value ?? SearchState();

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        // -----------------------------------------------------------
        // 🔵 AUTOCOMPLETE SUGGESTIONS
        // -----------------------------------------------------------
        ...state.suggestedAutocompletions!.map(
          (term) => _AutoCompleteTermRow(
            term: term,
            onInsert: () => vm.insertSearchedTerm(term),
          ),
        ),

        state.suggestedAutocompletions!.isNotEmpty
            ? Column(
                children: const [
                  Divider(color: Colors.white24, thickness: 0.3),
                  SizedBox(height: 10),
                ],
              )
            : const SizedBox.shrink(),

        // -----------------------------------------------------------
        // 🟣 SUGGESTED USERS
        // -----------------------------------------------------------
        ...state.suggestedUsers!.map(
          (user) => _AutoCompleteUserTile(
            user: user,
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                  settings: RouteSettings(
                    arguments: {"username": user.username},
                  ),
                ),
              ),
              state.suggestedUsers!.isNotEmpty
                  ? Column(
                      children: const [
                        Divider(color: Colors.white24, thickness: 0.3),
                      ],
                    )
                  : const SizedBox.shrink(),
            },
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
  //final void Function() getResult;
  const _AutoCompleteTermRow({required this.term, required this.onInsert});

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

// =====================================================================
// USER TILE FOR AUTOCOMPLETE USERS
// =====================================================================

class _AutoCompleteUserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const _AutoCompleteUserTile({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        color: theme.scaffoldBackgroundColor, // full rectangle
        child: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 22,
              backgroundImage: (user.profileImageUrl?.isNotEmpty ?? false)
                  ? NetworkImage(user.profileImageUrl!)
                  : null,
              backgroundColor: theme.brightness == Brightness.light
                  ? Color(0xFFd8d8d8)
                  : Color(0xFF4a4a4a),
              child:
                  (user.profileImageUrl == null ||
                      user.profileImageUrl!.isEmpty)
                  ? Icon(
                      Icons.person,
                      color: theme.brightness == Brightness.light
                          ? Color(0xFF57646e)
                          : Color(0xFF7b7f85),
                    )
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
                    style: TextStyle(
                      color: theme.brightness == Brightness.light
                          ? Color(0xFF0f1317)
                          : Color(0xFFd8d8d8),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "@${user.username}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.brightness == Brightness.light
                          ? Color(0xFF57646e)
                          : Color(0xFF7b7f85),
                      fontSize: 12,
                    ),
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
