import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversation_viewmodel.dart';

class ConversationsViewmodel extends PaginationNotifier<Conversation> {
  late AuthState _authState;
  late MessagesSocketService _socket;
  late ConversationsRepository _conversationsRepository;

  ConversationsViewmodel() : super(pageSize: 3) {}

  @override
  PaginationState<Conversation> build() {
    _socket = ref.read(messagesSocketServiceProvider);
    _conversationsRepository = ref.read(conversationsRepositoryProvider);
    _authState = ref.watch(authenticationProvider);

    Future.microtask(() async {
      await loadInitial();
    });

    // Listen for new messages
    _socket.incomingMessages.listen((messageDto) {
      final message = ChatMessage.fromDto(
        messageDto,
        currentUserId: _authState.user!.id!,
      );
      onNewMessageReceived(message);
    });

    _socket.incomingMessagesNotifications.listen((messageDto) {
      final message = ChatMessage.fromDto(
        messageDto,
        currentUserId: _authState.user!.id!,
      );
      onNewMessageReceived(message);
    });

    return const PaginationState<Conversation>();
  }

  // on recived message check if it belongs to any conversation? if yes refresh that conversation and set last message else add new conversation
  Future onNewMessageReceived(ChatMessage message) async {
    final conversationId = message.conversationId;
    final index = state.items.indexWhere((conv) => conv.id == conversationId);
    if (index != -1) {
      // refresh that conversation
      if (message.senderId == _authState.user!.id!) {
        return;
      }
      Conversation existingConv = state.items[index];
      Conversation updatedConv = existingConv.copyWith(
        lastMessage: message.text,
        lastMessageTime: message.time,
      );
      List<Conversation> updatedConvList = List.from(state.items);
      updatedConvList[index] = updatedConv;
      updatedConvList.sort((a, b) {
        var aTime = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        var bTime = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      state = state.copyWith(items: updatedConvList);
      
    } else {
      // fetch new conversation and add
      var user = await _conversationsRepository.getContactByUserId(message.senderId);
      Conversation conv = Conversation(
        id: conversationId ?? -1,
        name: user.name,
        userId: user.id,
        username: user.handle,
        lastMessageTime: message.time,
        avatarUrl: user.avatarUrl,
        lastMessage: message.text,
      );


      ref.read(conversationViewmodelProvider(conversationId!).notifier);

      List<Conversation> updatedConv = [...state.items, conv];

      var updatedFirstPage = await fetchPage(1);
      updatedConv = mergeList(state.items, updatedFirstPage.$1);

      state = state.copyWith(items: updatedConv);
    }
  }

  @override
  Future<(List<Conversation> items, bool hasMore)> fetchPage(int page) async {
    var (data, hasMore) = await _conversationsRepository.fetchConversations();
    for (var conv in data) {
      ref.read(conversationViewmodelProvider(conv.id).notifier);
    }
    return (data, hasMore);
  }

  @override
  List<Conversation> mergeList(List<Conversation> a, List<Conversation> b) {
    //merge but remove dublicate ids and sort by last message time
    final Map<int, Conversation> mergedMap = {
      for (var conv in a) conv.id: conv,
      for (var conv in b) conv.id: conv,
    };
    final mergedList = mergedMap.values.toList();
    mergedList.sort((a, b) {
      var aTime = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
      var bTime = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return mergedList;
  }
  

}

// Provider for the notifier
final conversationsViewmodel = NotifierProvider<
  ConversationsViewmodel, PaginationState<Conversation>>(() => ConversationsViewmodel());