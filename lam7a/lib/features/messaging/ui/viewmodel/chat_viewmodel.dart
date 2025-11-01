import 'dart:async';

import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/ui/state/chat_state.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_viewmodel.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {  
  final Logger _logger = getLogger(ChatViewModel);
  late int? _conversationId;
  late final int? _userId;

  late ConversationsRepository _conversationsRepository;
  late MessagesRepository _messagesRepository;
  late AuthState _authState;

  StreamSubscription<void>? _newMessagesSub;

  @override
  ChatState build({ int? conversationId, int? userId}) {
    _userId = userId;
    _conversationId = conversationId;

    ref.onDispose(_onDispose);

    _conversationsRepository = ref.read(conversationsRepositoryProvider);
    _messagesRepository = ref.read(messagesRepositoryProvider.notifier);
    _authState = ref.watch(authenticationProvider);

    Future.microtask(() async {
      await _getConvId();

      _newMessagesSub = _messagesRepository.onMessageRecieved(state.conversationId).listen((_)=>_onNewMessagesArrive());
      _messagesRepository.joinConversation(state.conversationId);
      _loadContant();
      _loadMessages();

      await loadMoreMessages();
      


    });
  

    return ChatState();
  }

  void _onDispose() {
    _logger.d("Disposing ChatViewModel");

    _newMessagesSub?.cancel();
    _newMessagesSub = null;
  }


  Future<void> _getConvId() async{
    if(_conversationId == null){
      _logger.d("Getting ConvId from UserId {$_userId}");
      int convId = await _conversationsRepository.getConversationIdByUserId(_userId!);

      if(convId == -1){
        _logger.e("UserId {$_userId} conversion got {$convId}");
        return;
      }

      _logger.d("Converted UserId to {$convId}");
      state = state.copyWith(conversationId: convId);
    }else{
      state = state.copyWith(conversationId: _conversationId ?? -1);
    }
  }

  Future<void> _loadContant() async {
    // var chatsRepository = await ref.read(chatsRepositoryProvider.future);

    // if (_user != null) return;
    // try {
    //   // final contact = await _chatsRepository.fetchContactById(_userId);
    //   // _user = contact;

    //   _user = Contact(
    //     id: _userId,
    //     name: "Test User",
    //     handle: "@testuser",
    //     avatarUrl: "https://avatar.iran.liara.run/public",
    //   );
    //   await Future.delayed(const Duration(seconds: 10)); // simulate delay
    //   state = state.copyWith(contact: AsyncData(_user!));
    // } catch (e) {
    //   // handle error if needed
    // }
  }

  Future<void> _loadMessages() async {
    state = state.copyWith(messages: const AsyncLoading());
    try {
      final data = await _messagesRepository.fetchMessage(state.conversationId);
      state = state.copyWith(messages: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(messages: AsyncError(e, st));
    }
  }

  void _onNewMessagesArrive(){
    _refreshMessages();
  }

  void _refreshMessages() {
    try {
      final data = _messagesRepository.fetchMessage(state.conversationId);
      state = state.copyWith(messages: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(messages: AsyncError(e, st));
    }
  }

  Future<void> sendMessage(String message) async {
    _messagesRepository.sendMessage(_authState.user!.id!, state.conversationId, message.trim());
  }


  Future<void> loadMoreMessages() async {
    if(state.loadingMoreMessages) return;
    if(!state.hasMoreMessages){
      _logger.d("Done Loading all messages");
      return;
    }
    state = state.copyWith(loadingMoreMessages: true);

    var hasMore = await _messagesRepository.loadMessageHistory(state.conversationId);

    state = state.copyWith(loadingMoreMessages: false, hasMoreMessages: hasMore);
  }

  Future<void> refresh() async {
    await  _loadMessages();
  }

}