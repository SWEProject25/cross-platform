import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/services/socket_service.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';

// ----- Example model -----
class Item {
  final int id;
  final String title;
  Item({required this.id, required this.title});
}

// ----- Pagination state -----
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

// ----- Fake repository (replace with real API) -----
class Repository {
  // Simulates fetching a page of items. page is 1-based.
  Future<List<Item>> fetchItems({
    required int page,
    required int pageSize,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network
    if (page > 5) return []; // no more after page 5
    final start = (page - 1) * pageSize;
    return List.generate(
      pageSize,
      (i) => Item(id: start + i, title: 'Item ${start + i}'),
    );
  }
}

// Provide repository
final repositoryProvider = Provider<Repository>((ref) => Repository());

// ----- Pagination notifier -----
abstract class PaginationNotifier<T> extends StateNotifier<PaginationState<T>> {
  final int pageSize;
  PaginationNotifier({this.pageSize = 20}) : super(PaginationState<T>());

  // initial load
  Future<void> loadInitial() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newPage = 1;
      final List<T> items = await _fetchPage(newPage);
      final hasMore = items.length == pageSize;
      state = state.copyWith(
        items: items,
        page: newPage,
        isLoading: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  // refresh (pull-to-refresh)
  Future<void> refresh() async {
    if (state.isRefreshing) return;
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final newPage = 1;
      final items = await _fetchPage(newPage);
      final hasMore = items.length == pageSize;
      state = state.copyWith(
        items: items,
        page: newPage,
        isRefreshing: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e);
    }
  }

  // load more (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.isLoading ||
        state.isRefreshing)
      return;
    state = state.copyWith(isLoadingMore: true, error: null);
    try {
      final nextPage = state.page + 1;
      final newItems = await _fetchPage(nextPage);
      final hasMore = newItems.length == pageSize;
      state = state.copyWith(
        items: _mergeList(state.items, newItems),
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

  Future<List<T>> _fetchPage(int page);
  List<T> _mergeList(List<T> a, List<T> b);
}

class ConversationsNotifier extends PaginationNotifier<Conversation> {
  late AuthState _authState;
  final MessagesSocketService _socket;
  final ConversationsRepository _conversationsRepository;

  ConversationsNotifier(
    Ref ref,
    MessagesSocketService socket,
    MessagesRepository messagesRepository,
    ConversationsRepository conversationsRepository,
  ) : _socket = socket,
      _conversationsRepository = conversationsRepository,
      super(pageSize: 20) {
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
  }

  // on recived message check if it belongs to any conversation? if yes refresh that conversation and set last message else add new conversation
  void onNewMessageReceived(ChatMessage message) async {
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

      var updatedFirstPage = await _fetchPage(1);
      updatedConv = _mergeList(state.items, updatedFirstPage);

      state = state.copyWith(items: updatedConv);
    }
  }

  @override
  Future<List<Conversation>> _fetchPage(int page) {
    return _conversationsRepository.fetchConversations();
  }

  @override
  List<Conversation> _mergeList(List<Conversation> a, List<Conversation> b) {
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
final conversationsProvider =
    StateNotifierProvider<ConversationsNotifier, PaginationState<Conversation>>(
      (ref) => ConversationsNotifier(
        ref,
        ref.read(messagesSocketServiceProvider),
        ref.read(messagesRepositoryProvider.notifier),
        ref.read(conversationsRepositoryProvider),
      ),
    );
