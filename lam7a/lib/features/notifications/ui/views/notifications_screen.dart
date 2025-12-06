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
  void deactivate() {
    // TODO: implement deactivate
    ref.read(notificationsViewModelProvider.notifier).markAllAsRead();

    super.deactivate();
  }

@override
  Widget build(BuildContext context) {
    var viewModel = ref.watch(notificationsViewModelProvider.notifier);
    var state = ref.watch(notificationsViewModelProvider);
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
                    _buildNotificationsListView(
                      context,
                      state.hasMore,
                      _allScrollController,
                      viewModel,
                      viewModel.allNotifications(),
                    ),
                    _buildNotificationsListView(
                      context,
                      state.hasMore,
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
    BuildContext context,
    bool hasMore,
    ScrollController controller,
    NotificationsViewModel viewModel,
    AsyncValue<List<NotificationModel>> notifications,
  ) {
    ThemeData theme = Theme.of(context);
    return notifications.when(
      data: (data) => RefreshIndicator(
        onRefresh: () => viewModel.refresh(),
        child: data.isEmpty ? 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(flex: 3),
                Text("Join the conversation!", textAlign: TextAlign.left, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.bold),),
                Text("When someone mentions you, you'll find\nit here.", textAlign: TextAlign.left, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),),
                Spacer(flex: 2),
              ],
            ),
          ) :
        
        
        ListView.separated(
          controller: controller,
          itemCount: data.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            final n = data[index];
            return Column(
              children: [
                NotificationItem(notification: n, onTap: () {
                  viewModel.handleNotificationAction(n);
                }),
                if(index == data.length - 1)
                  hasMore ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ):
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
                      child: Text("No more notifications for now", style: TextStyle(color: Colors.grey)),
                    ),
              ],
            );
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
