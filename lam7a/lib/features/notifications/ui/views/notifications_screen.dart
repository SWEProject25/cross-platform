import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/all_notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/mention_notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/widgets/notification_item.dart';
import 'package:lam7a/features/notifications/ui/widgets/paginated_list.dart';

class NotificationsScreen extends ConsumerStatefulWidget  {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate

    try {
      ref.read(allNotificationsViewModelProvider.notifier).markAllAsRead();
      ref.read(mentionNotificationsViewModelProvider.notifier).markAllAsRead();

    } catch (e) {
      // already removed
    }

    WidgetsBinding.instance.removeObserver(this);
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      ref.read(allNotificationsViewModelProvider.notifier).markAllAsRead();
      ref.read(mentionNotificationsViewModelProvider.notifier).markAllAsRead();
    }
  }

  void handleNotificationTap(NotificationModel notification) {
    if (notification.type != NotificationType.mention || notification.type != NotificationType.reply || notification.type != NotificationType.quote) {
      ref
          .read(allNotificationsViewModelProvider.notifier)
          .handleNotificationAction(notification);
    }

    ref
        .read(mentionNotificationsViewModelProvider.notifier)
        .markNotAsRead(notification.notificationId);
    ref
        .read(allNotificationsViewModelProvider.notifier)
        .markNotAsRead(notification.notificationId);
  }

  @override
  Widget build(BuildContext context) {
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
                        key: Key('notification_item_${item.notificationId}'),
                        notification: item,
                        onTap: () => handleNotificationTap(item),
                      ),
                      noDataWidget: _buildNoData(),
                      endOfListWidget: _buildEndOfList(),
                    ),
                    PaginatedListView(
                      viewModelProvider: mentionNotificationsViewModelProvider,
                      builder: (item) => NotificationItem(
                        key: Key('notification_item_${item.notificationId}'),
                        notification: item,
                        onTap: () => handleNotificationTap(item),
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
