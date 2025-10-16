// dm List Page ViewModel
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/messaging/model/Conversation.dart';
import 'package:lam7a/features/messaging/repository/chats_repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dm_list_page_viewmodel.g.dart';

@riverpod
class DMListPageViewModel extends _$DMListPageViewModel {
  late final ChatsRepository _chatsRepository;

  @override
  Future<List<Conversation>> build() async {
    _chatsRepository = ref.read(chatsRepositoryProvider);

    return _loadConversations();
  }

  Future<List<Conversation>> _loadConversations() async {
    final conversations = await _chatsRepository.fetchConversations();
    return conversations;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await _chatsRepository.fetchConversations();
    });
  }
}


