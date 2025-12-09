import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_search_state.freezed.dart';

@freezed
abstract class ContactSearchState with _$ContactSearchState {
  const factory ContactSearchState({
    @Default(AsyncValue.loading()) AsyncValue<List<Contact>> contacts,
    @Default("") String searchQuery,
    @Default(null) String? searchQueryError,
    @Default({}) Map<String, bool> isTyping,

    @Default(false) bool loadingConversationId,
  }) = _ContactSearchState;
}