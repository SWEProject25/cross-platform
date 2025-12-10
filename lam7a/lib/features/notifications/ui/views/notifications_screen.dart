import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/all_notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/mention_notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/widgets/notification_item.dart';
import 'package:lam7a/features/notifications/ui/widgets/paginated_list.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _allScrollController = ScrollController();
  final ScrollController _mentionsScrollController = ScrollController();

  @override
  void initState() {
    _allScrollController.addListener(() {
      final trigger = 0.8 * _allScrollController.position.maxScrollExtent;

      if (_allScrollController.position.pixels > trigger) {
        ref.read(allNotificationsViewModelProvider.notifier).loadMore();
      }
    });
    _mentionsScrollController.addListener(() {
      final trigger = 0.8 * _mentionsScrollController.position.maxScrollExtent;

      if (_mentionsScrollController.position.pixels > trigger) {
        ref.read(mentionNotificationsViewModelProvider.notifier).loadMore();
      }
    });
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    
    ref.read(allNotificationsViewModelProvider.notifier).markAllAsRead();
    ref.read(mentionNotificationsViewModelProvider.notifier).markAllAsRead();

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var viewmodel = allNotificationsViewModelProvider;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(context),

              Expanded(
                child: TabBarView(
                  children: [
                    PaginatedListView(
                      viewModelProvider: allNotificationsViewModelProvider,
                      builder: (item) => NotificationItem(
                        notification: item,
                        onTap: () {
                          ref
                              .read(allNotificationsViewModelProvider.notifier)
                              .handleNotificationAction(item);
                        },
                      ),
                      noDataWidget: _buildNoData(),
                      endOfListWidget: _buildEndOfList(),
                    ),
                    PaginatedListView(
                      viewModelProvider: mentionNotificationsViewModelProvider,
                      builder: (item) => NotificationItem(
                        notification: item,
                        onTap: () {
                          ref
                              .read(
                                mentionNotificationsViewModelProvider.notifier,
                              )
                              .handleNotificationAction(item);
                        },
                      ),
                      noDataWidget: _buildNoData(),
                      endOfListWidget: _buildEndOfList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoData() {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(flex: 3),
          Text(
            "Join the conversation!",
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "When someone mentions you, you'll find\nit here.",
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      labelColor: Theme.of(context).textTheme.bodyLarge?.color,
      unselectedLabelColor: Theme.of(
        context,
      ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
      // indicatorColor: Colors.blue,
      tabs: [
        Tab(text: "All"),
        Tab(text: "Mentions"),
      ],
    );
  }

  Widget _buildEndOfList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
      child: Text(
        "No more notifications for now",
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
