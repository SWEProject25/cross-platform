import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/ui/state/conversations_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_viewmodel.g.dart';

@riverpod
class ConversationsViewModel extends _$ConversationsViewModel {
  
  late ConversationsRepository _conversationsRepository;

  @override
  ConversationsState build() {
    _conversationsRepository = ref.read(conversationsRepositoryProvider);

    Future.microtask(() async {
      await _loadConversations();
      await _loadContacts();
    });

    return const ConversationsState();
  }

  Future<void> _loadConversations() async {

    state = state.copyWith(conversations: const AsyncLoading());
    try {
      final data = await _conversationsRepository.fetchConversations();
      print("Got Data: $data");
      state = state.copyWith(conversations: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(conversations: AsyncError(e, st));
    }
  }

  Future<void> _loadContacts() async {

    if (state.contacts is AsyncData) return; // load only once
    state = state.copyWith(contacts: const AsyncLoading());
    try {
      final data = await _conversationsRepository.fetchContacts();
      state = state.copyWith(contacts: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(contacts: AsyncError(e, st));
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      _loadConversations(),
      _loadContacts(),
    ]);
  }

}


