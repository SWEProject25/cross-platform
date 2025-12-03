import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/widgets/notification_item.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {

  final ScrollController _allScrollController = ScrollController();
  final ScrollController _mentionsScrollController = ScrollController();

@override
  void initState() {
    _allScrollController.addListener(() => scrollListener(_allScrollController));
    _mentionsScrollController.addListener(() => scrollListener(_mentionsScrollController));

    super.initState();
  }

  void scrollListener(ScrollController controller) {
    final trigger = 0.8 * controller.position.maxScrollExtent;

    if (controller.position.pixels > trigger) {
      ref.read(notificationsViewModelProvider.notifier).loadMore();
    }
  }

@override
  Widget build(BuildContext context) {
    var viewModel = ref.watch(notificationsViewModelProvider.notifier);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(context),

              Expanded(
                child: TabBarView(
                  children: [
                    _buildNotificationsListView(
                      _allScrollController,
                      viewModel,
                      viewModel.allNotifications(),
                    ),
                    _buildNotificationsListView(
                      _mentionsScrollController,
                      viewModel,
                      viewModel.mentionNotifications(),
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

  Widget _buildNotificationsListView(
    ScrollController controller,
    NotificationsViewModel viewModel,
    AsyncValue<List<NotificationModel>> notifications,
  ) {
    return notifications.when(
      data: (data) => RefreshIndicator(
        onRefresh: () => viewModel.refresh(),
        child: ListView.separated(
          controller: controller,
          itemCount: data.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            final n = data[index];
            return NotificationItem(notification: n, onTap: () {
              viewModel.handleNotificationAction(n);
            });
          },
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      labelColor: Theme.of(context).textTheme.bodyLarge?.color,
      unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
      // indicatorColor: Colors.blue,
      tabs: [
        Tab(text: "All"),
        Tab(text: "Mentions"),
      ],
    );
  }
}
