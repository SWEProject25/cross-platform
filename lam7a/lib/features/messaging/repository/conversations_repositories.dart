import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_repositories.g.dart';

@riverpod
ConversationsRepository conversationsRepository(Ref ref) {
  return ConversationsRepository(
    ref.read(dmsApiServiceProvider),
    ref.watch(authenticationProvider),
    ref.read(authenticationImplRepositoryProvider)
  );
}

class ConversationsRepository {
  final DMsApiService _apiService;
  final AuthState _authState;
  final AuthenticationRepositoryImpl authRepo;

  ConversationsRepository(this._apiService, this._authState, this.authRepo);

  Future<(List<Conversation> data, bool hasMore)> fetchConversations() async {
    if (!_authState.isAuthenticated) return ([] as List<Conversation>, false);

    var conversationsDto = await _apiService.getConversations();

    var conversations = conversationsDto.data.map((x) {
      return Conversation.fromDto(x);
    }).toList();

    return (conversations, conversationsDto.metadata.totalPages != conversationsDto.metadata.page);
  }

  Future<Conversation> getConversationById(int convId) async {
    var conversationDto = await _apiService.getConversationById(convId);
    return Conversation.fromDto(conversationDto.data);
  }

  Future<int> getConversationIdByUserId(int userId) async {
    return await _apiService.createConversation(userId);
  }

  Future<List<Contact>> searchForContacts(
    String query,
    int page, [
    int limit = 20,
  ]) async {
    return await _apiService.searchForContacts(query, page, limit);
  }

  Future<List<Contact>> searchForContactsExtended(
    String query,
    int page, [
    int limit = 20,
  ]) async {
    if(query.length <= 1){
      var res = await authRepo.getUsersToFollow(50);
      return res.map((x)=> Contact(id: x.id??-1, name: x.profile?.name?? "Unkown", handle: x.username?? "@unkown")).toList();
    }else{
      return await _apiService.searchForContacts(query, page, limit);
    }
  }

  Future<Contact> getContactByUserId(int userId) async {
    return await _apiService.getContactByUserId(userId);
  }

  Future<int> getAllUnseenConversations() async {
    return await _apiService.getNumberOfUnseenConversations(null);
  }
}
