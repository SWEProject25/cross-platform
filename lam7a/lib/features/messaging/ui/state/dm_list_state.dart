import 'package:lam7a/features/messaging/model/Contact.dart';
import 'package:lam7a/features/messaging/model/Conversation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dm_list_state.freezed.dart';

@freezed
abstract class DMListState with _$DMListState {
  const factory DMListState({
    @Default(AsyncValue.loading()) AsyncValue<List<Conversation>> conversations,
    @Default(AsyncValue.loading()) AsyncValue<List<Contact>> contacts,
  }) = _DMListState;
}