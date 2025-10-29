import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/local_cache.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_repository.g.dart';

@riverpod
class MessagesRepository extends _$MessagesRepository {

  late LocalCache _cache;
  late MessagesSocketService _socket;
  late AuthState _authState;

  @override
  void build() {
    _cache = LocalCache();
    _socket = ref.read(messagesSocketServiceProvider);
    _authState = ref.watch(authenticationProvider);

    _socket.incomingMessages.listen(_onReceivedMessage);
  }

  void _onReceivedMessage(MessageDto data) {

    var message = ChatMessage(id: data.id ?? -1, text: data.text ?? "(Missing Message)", time: data.createdAt!, isMine: _authState.isAuthenticated && data.senderId == _authState.user!.id);

    _cache.addMessage(message.conversationId?? -1, message);
  }


  // 1️⃣ Load history from API
  Future<List<ChatMessage>> fetchMessage(int chatId) async {
    // final response = await apiClient.get('/chats/$chatId/messages');
    // final messages = (response.data as List).map((json) => Message.fromJson(json)).toList();
    // cache.saveMessages(chatId, messages);
    // return messages;
    return _cache.getMessages(chatId);
  }

  // final SocketService socketService;
  // final ApiClient apiClient; // For HTTP fetching
  // final LocalCache cache;

  // MessagesRepository(this.socketService, this.apiClient, this.cache);

  // // // 1️⃣ Load history from API
  // // Future<List<Message>> fetchMessageHistory(String chatId) async {
  // //   final response = await apiClient.get('/chats/$chatId/messages');
  // //   final messages = (response.data as List).map((json) => Message.fromJson(json)).toList();
  // //   cache.saveMessages(chatId, messages);
  // //   return messages;
  // // }

  // // 2️⃣ Listen to new messages via socket
  // Stream<Message> listenToNewMessages() async* {
  //   final controller = StreamController<Message>();
  //   socketService.on('newMessage', (data) {
  //     final message = Message.fromJson(data);
  //     cache.addMessage(message.chatId, message);
  //     controller.add(message);
  //   });
  //   yield* controller.stream;
  // }

  // // 3️⃣ Send a message
  // void sendMessage(Message message) {
  //   socketService.emit('sendMessage', message.toJson());
  // }
}
