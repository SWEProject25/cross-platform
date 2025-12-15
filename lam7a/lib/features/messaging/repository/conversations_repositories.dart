import 'package:hive_flutter/hive_flutter.dart';
import 'package:lam7a/core/hive_types.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/common/dtos/api_response.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_repositories.g.dart';

@riverpod
ConversationsRepository conversationsRepository(Ref ref) {
  return ConversationsRepository(
    ref.read(dmsApiServiceProvider),
    ref.watch(authenticationProvider),
    ref.read(authenticationImplRepositoryProvider),
    ref.read(profileRepositoryProvider),
  );
}

class ConversationsRepository {
  final DMsApiService _apiService;
  final AuthState _authState;
  final AuthenticationRepositoryImpl authRepo;
  final ProfileRepository _profileRepository;

  ConversationsRepository(this._apiService, this._authState, this.authRepo, this._profileRepository);

  Future<(List<Conversation> data, bool hasMore)> fetchConversations() async {
    if (!_authState.isAuthenticated) return (List<Conversation>.empty(), false);

    
    ApiResponse<List<ConversationDto>>? conversationsDto;
    try {
      conversationsDto = await _apiService.getConversations();
    } catch (e) {
      // Fallback to local storage
      var hive = await HiveTypes().openBoxIfNeeded<Conversation>('conversations');
      var conversations = hive.values.toList();
      conversations.sort((a, b) {
        var aTime = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        var bTime = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      return (conversations, false);
    }

    var conversations = conversationsDto.data.map((x) {
      return Conversation.fromDto(x);
    }).toList();

    var hive = await HiveTypes().openBoxIfNeeded<Conversation>('conversations');
    for (var conv in conversations) {
      hive.put(conv.id, conv);
    }

    return (conversations, conversationsDto.metadata.totalPages != conversationsDto.metadata.page);
  }

  Future<Conversation> getConversationById(int convId) async {
    var conversationDto = await _apiService.getConversationById(convId);
    return Conversation.fromDto(conversationDto);
  }

  Future<int> getConversationIdByUserId(int userId) async {
    return await _apiService.createConversation(userId);
  }

  Future<List<Contact>> searchForContacts(
    String query,
    int page, [
    int limit = 20,
  ]) async {
    if(query.length <= 1){

      if (!(_authState.isAuthenticated)) {
        return [];
      }
      
      var followersRes = await _profileRepository.getFollowers(_authState.user!.id!);
      var followers = followersRes.map((x)=> Contact(id: x.id ?? -1, name: x.name?? "Unkown", handle: x.username?? "@unkown", avatarUrl: x.profileImageUrl)).toList();

      var followingRes = await _profileRepository.getFollowing(_authState.user!.id!);
      var following = followingRes.map((x)=> Contact(id: x.id ?? -1, name: x.name?? "Unkown", handle: x.username?? "@unkown", avatarUrl: x.profileImageUrl)).toList();

      var suggestedRes = await authRepo.getUsersToFollow(50);
      var suggested = suggestedRes.map((x)=> Contact(id: x.id??-1, name: x.profile?.name?? "Unkown", handle: x.username?? "@unkown", avatarUrl: x.profile?.profileImageUrl)).toList();

      // Remove duplicates ids and combine lists
      var allContactsMap = <int, Contact>{};
      for (var contact in [...followers, ...following, ...suggested]) {
        allContactsMap[contact.id] = contact;
      }
      return allContactsMap.values.toList();
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
