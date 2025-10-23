import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/repository/chats_repositories.dart';
import 'package:lam7a/features/messaging/ui/state/chat_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_viewmodel.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {
  late final ChatsRepository _chatsRepository;
  
  late final String _userId;
  late Contact? _user;

  @override
  ChatState build(String userId, [Contact? user]) {
    _chatsRepository = ref.read(chatsRepositoryProvider);
    _userId = userId;
    _user = user;

    Future.microtask(() async {
      _loadContant();
      _loadMessages();
    });
  

    return ChatState();
  }

  Future<void> _loadContant() async {
    if (_user != null) return;
    try {
      // final contact = await _chatsRepository.fetchContactById(_userId);
      // _user = contact;

      _user = Contact(
        id: _userId,
        name: "Test User",
        handle: "@testuser",
        avatarUrl: "https://avatar.iran.liara.run/public",
      );
      await Future.delayed(const Duration(seconds: 10)); // simulate delay
      state = state.copyWith(contact: AsyncData(_user!));
    } catch (e) {
      // handle error if needed
    }
  }

  Future<void> _loadMessages() async {
    state = state.copyWith(messages: const AsyncLoading());
    try {
      final data = await _chatsRepository.fetchMessages(_userId);
      state = state.copyWith(messages: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(messages: AsyncError(e, st));
    }
  }


  Future<void> sendMessage(String message) async {
  }

}