import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/ui/state/notifications_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_viewmodel.g.dart';

@riverpod
class NotificationsViewModel extends _$NotificationsViewModel {
  late final NotificationsRepository _notificationsRepository;

  @override
  NotificationsState build() {
    _notificationsRepository = ref.read(notificationsRepositoryProvider);

    Future.microtask(() async {
      await _loadNotifications();
    });

    return const NotificationsState();
  }

  Future<void> _loadNotifications() async {
    state = state.copyWith(notifications: const AsyncLoading());

    try {
      final notifications = await _notificationsRepository.fetchNotifications();
      state = state.copyWith(notifications: AsyncData(notifications));
    } catch (e, st) {
      state = state.copyWith(
        notifications: AsyncError(e, st),
      );
    }
  }

  Future<void> refresh() async {
    await _loadNotifications();
  }
}
