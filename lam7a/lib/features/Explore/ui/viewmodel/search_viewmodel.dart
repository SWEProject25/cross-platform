import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/search_state.dart';
import '../../repository/search_repository.dart';
import '../../../../../core/models/user_model.dart';

final searchViewModelProvider =
    AsyncNotifierProvider<SearchViewModel, SearchState>(() {
      return SearchViewModel();
    });

class SearchViewModel extends AsyncNotifier<SearchState> {
  Timer? _debounce;
  late final SearchRepository _searchRepository;

  late final TextEditingController searchController;

  @override
  Future<SearchState> build() async {
    ref.onDispose(() {
      _debounce?.cancel();
      searchController.dispose();
    });

    // FIX: Initialize controller once
    searchController = TextEditingController();

    _searchRepository = ref.read(searchRepositoryProvider);

    final autocompletes = await _searchRepository.getCachedAutocompletes();
    final users = await _searchRepository.getCachedUsers();

    final loaded = SearchState(
      suggestedAutocompletions: [],
      suggestedUsers: [],
      recentSearchedTerms: autocompletes,
      recentSearchedUsers: users,
    );

    state = AsyncData(loaded);

    return loaded;
  }

  void onChanged(String query) {
    _debounce?.cancel();

    if (query.isEmpty) {
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

    searchController.text = query;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      await _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isNotEmpty) {
      try {
        state = const AsyncLoading();

        final userResults = await _searchRepository.searchUsers(
          trimmedQuery,
          8,
          1,
        );

        final prev = state.value;

        state = AsyncData(
          (prev ?? state.requireValue).copyWith(
            suggestedAutocompletions: const [],
            suggestedUsers: userResults,
          ),
        );
      } catch (e, st) {
        state = AsyncError(e, st);
      }
    }
  }

  void insertSearchedTerm(String term) {
    final current = state.value;
    if (current == null) return;

    searchController.text = term;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );

    state = AsyncData(
      current.copyWith(suggestedUsers: [], suggestedAutocompletions: []),
    );

    onChanged(term);
  }

  Future<void> pushUser(UserModel user) async {
    await _searchRepository.pushUser(user);

    final current = state.value;
    if (current == null) return;

    final updatedUsers = await _searchRepository.getCachedUsers();

    state = AsyncData(current.copyWith(recentSearchedUsers: updatedUsers));
  }

  Future<void> pushAutocomplete(String term) async {
    await _searchRepository.pushAutocomplete(term);

    final current = state.value;
    if (current == null) return;

    final updatedTerms = await _searchRepository.getCachedAutocompletes();

    state = AsyncData(current.copyWith(recentSearchedTerms: updatedTerms));
  }
}
