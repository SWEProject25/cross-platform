import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';

class PaginationState<T> {
  final List<T> items;
  final int page;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasMore;
  final Object? error;

  const PaginationState({
    this.items = const [],
    this.page = 0,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    int? page,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasMore,
    Object? error,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}
// ----- Pagination notifier -----
abstract class PaginationNotifier<T> extends Notifier<PaginationState<T>> {
  final int pageSize;
  PaginationNotifier({this.pageSize = 20}) : super();

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newPage = 1;
      final (newItems, hasMore) = await fetchPage(newPage);
      state = state.copyWith(
        items: newItems,
        page: newPage,
        isLoading: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final newPage = 1;
      final (newItems, hasMore) = await fetchPage(newPage);
      state = state.copyWith(
        items: newItems,
        page: newPage,
        isRefreshing: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.isLoading ||
        state.isRefreshing)
      return;
    state = state.copyWith(isLoadingMore: true, error: null);
    try {
      final nextPage = state.page + 1;
      final (newItems, hasMore) = await fetchPage(nextPage);
      state = state.copyWith(
        items: mergeList(state.items, newItems),
        page: nextPage,
        isLoadingMore: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  // helper: use repo to fetch, adapt to T

  Future<(List<T> items, bool hasMore)> fetchPage(int page);
  List<T> mergeList(List<T> a, List<T> b) {
    return [...a, ...b];
  }
}

class ConversationsNotifier extends PaginationNotifier<Conversation> {
  late AuthState _authState;
  late MessagesSocketService _socket;
  late ConversationsRepository _conversationsRepository;

  ConversationsNotifier() : super(pageSize: 20) {}

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

      List<Conversation> updatedConv = [...state.items, conv];

      var updatedFirstPage = await fetchPage(1);
      updatedConv = mergeList(state.items, updatedFirstPage.$1);

      state = state.copyWith(items: updatedConv);
    }
  }

  @override
  Future<(List<Conversation> items, bool hasMore)> fetchPage(int page) async {
    return await _conversationsRepository.fetchConversations();
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
final conversationsProvider = NotifierProvider<
  ConversationsNotifier, PaginationState<Conversation>>(() => ConversationsNotifier());