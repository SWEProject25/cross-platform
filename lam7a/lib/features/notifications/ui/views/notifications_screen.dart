import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/widgets/notification_item.dart';

class NotificationsScreen extends ConsumerWidget {

  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewModel = ref.watch(notificationsViewModelProvider.notifier);
    var notificationsState = ref.watch(notificationsViewModelProvider);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),

              Expanded(
                child: TabBarView(
                  children: [
                    _buildNotificationsListView(
                      viewModel,
                      notificationsState.allNotifications,
                    ),
                    _buildNotificationsListView(
                      viewModel,
                      notificationsState.mentionNotifications,
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
    NotificationsViewModel viewModel,
    AsyncValue<List<NotificationModel>> notifications,
  ) {
    return notifications.when(
      data: (data) => RefreshIndicator(
        onRefresh: () => viewModel.refresh(),
        child: ListView.separated(
          itemCount: data.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            final n = data[index];
            return NotificationItem(notification: n);
          },
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  TabBar _buildTabBar() {
    return const TabBar(
      labelColor: Colors.black,
      indicatorColor: Colors.blue,
      tabs: [
        Tab(text: "All"),
        Tab(text: "Mentions"),
      ],
    );
  }
}
