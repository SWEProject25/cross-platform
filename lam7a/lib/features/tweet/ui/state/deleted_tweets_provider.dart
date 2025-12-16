// coverage:ignore-file
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global set of deleted tweet IDs used to hide tweets in lists
/// without having to refetch entire timelines.
final deletedTweetsProvider =
    NotifierProvider<DeletedTweetsNotifier, Set<String>>(
  DeletedTweetsNotifier.new,
);

class DeletedTweetsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void add(String id) {
    state = {...state, id};
  }

  void remove(String id) {
    final next = {...state};
    next.remove(id);
    state = next;
  }
}
