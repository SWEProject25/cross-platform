import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/app_icons.dart';
import 'package:lam7a/core/widgets/app_svg_icon.dart';
import 'package:lam7a/features/messaging/providers/conversations_provider.dart';
import 'package:lam7a/features/messaging/ui/view/find_contacts_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversations_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/widgets/conversation_tile.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';

class ConversationsScreen extends ConsumerWidget {
  static const routeName = '/dm';

  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final dMListPageViewModel = ref.watch(conversationsViewModelProvider);
    return Scaffold(
      // appBar: DMAppBar(title: 'Direct Message'),
      body: dMListPageViewModel.conversations.when(
        data: (data) {
          return data.isEmpty
              ? Padding(
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
                            MaterialPageRoute(
                              builder: (context) => FindContactsScreen(),
                            ),
                          );
                        },
                        child: Text("Write a message"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  key: Key(MessagingUIKeys.conversationsListView),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final chat = data[index];
                    return ConversationTile(id: chat.id);
                  },
                );
        },
        error: (error, stack) {
          return Center(child: Text('Error: $error $stack'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
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
}


