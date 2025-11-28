import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/search_state.dart';
import '../../../../core/models/user_model.dart';

final searchViewModelProvider =
    AsyncNotifierProvider<SearchViewModel, SearchState>(() {
      return SearchViewModel();
    });

class SearchViewModel extends AsyncNotifier<SearchState> {
  Timer? _debounce;

  @override
  Future<SearchState> build() async {
    ref.onDispose(() {
      _debounce?.cancel();
    });

    return SearchState();
  }

  void onChanged(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      final prev = state.value;
      if (prev == null) return;

      state = AsyncData(
        prev.copyWith(
          suggestedAutocompletions: const [],
          suggestedUsers: const [],
        ),
      );
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _search(query);
    });
  }

  void _search(String q) {}
}
