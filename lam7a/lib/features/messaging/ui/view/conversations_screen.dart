import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/app_icons.dart';
import 'package:lam7a/core/widgets/app_svg_icon.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/ui/view/find_contacts_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversations_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/widgets/conversation_tile.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';
import 'package:lam7a/features/notifications/ui/widgets/paginated_list.dart';

class ConversationsScreen extends ConsumerWidget {
  static const routeName = '/dm';

  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final state = ref.watch(conversationsViewmodel);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(conversationsViewmodel.notifier).refresh(),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
            ? CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Center(child: Text('Error: ${state.error}'))
                  ),
                ],
              )
            : state.items.isEmpty
            ? CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Center(child: buildNoConversations(theme, context)),
                  ),
                ],
              )
            : buildConversationsList(state),
      ),

      floatingActionButton: FloatingActionButton(
        key: Key(MessagingUIKeys.conversationsFab),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => FindContactsScreen()));
        },
        child: AppSvgIcon(AppIcons.add_message),
      ),
    );
  }

  Widget buildConversationsList(PaginationState<Conversation> state) {
    return PaginatedListView(viewModelProvider: conversationsViewmodel, builder: (chat){
        return ConversationTile(id: chat.id, conversation: chat);
    });
  }

  Padding buildNoConversations(ThemeData theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to your\ninbox!",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Drop a line, share posts and more with private conversations between you and onthers on X.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 30),
          FilledButton(
            key: Key(MessagingUIKeys.conversationsEmptyStateWriteButton),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FindContactsScreen()),
              );
            },
            child: Text("Write a message"),
          ),
        ],
      ),
    );
  }
}
