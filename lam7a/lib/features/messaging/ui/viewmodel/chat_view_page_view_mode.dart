import 'package:lam7a/features/messaging/repository/chats_repositories.dart';
import 'package:lam7a/features/messaging/ui/state/chat_page_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_view_page_view_mode.g.dart';

@riverpod
class ChatViewPageViewModel extends _$ChatViewPageViewModel {
  late final ChatsRepository _chatsRepository;
  
  @override
  ChatPageState build() {
    _chatsRepository = ref.read(chatsRepositoryProvider);

    Future.microtask(() async {
      await _loadMessages();
    });

    return ChatPageState();
  }

  Future<void> _loadMessages() async {
    state = state.copyWith(messages: const AsyncLoading());
    try {
      final data = await _chatsRepository.fetchMessages();
      state = state.copyWith(messages: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(messages: AsyncError(e, st));
    }
  }

}