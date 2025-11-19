// lib/features/search/viewmodel/search_viewmodel.dart
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import '../state/search_state.dart';
import '../../../../core/models/user_model.dart';

part 'search_viewmodel.g.dart';

@riverpod
class SearchViewModel extends _$SearchViewModel {
  Timer? _debounce;

  @override
  Future<SearchState> build() async {
    // start with an empty SearchState
    ref.onDispose(() {
      _debounce?.cancel();
    });
    return SearchState();
  }

  // Debounced search called by the UI on text change
  void onChanged(String query) {
    // Cancel previous timer
    _debounce?.cancel();

    // If empty -> clear search results/suggestions but keep recents
    if (query.trim().isEmpty) {
      // keep previous controller and recents, clear suggestions
      final prev = state.value;
      if (prev != null) {
        state = AsyncData(
          prev.copyWith(
            suggestedAutocompletions: const [],
            suggestedUsers: const [],
          ),
        );
      }
      return;
    }

    // Debounce (300ms)
    _debounce = Timer(const Duration(milliseconds: 300), () {
      search(query);
    });
  }

  // Fake/mocked async search (simulate API)
  Future<void> search(String query) async {
    final prev = state.value ?? SearchState();
    // Keep UI visible; set loading state only for the suggestion area by using AsyncLoading
    // but we avoid wiping the recents: we'll set AsyncLoading while keeping previous data if you prefer.
    state = const AsyncLoading();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 350));

      // Mocked results
      final mockUsers = [
        UserModel(
          id: 1,
          username: "@Mohamed",
          name: "Mohamed",
          profileImageUrl:
              "https://cdn-icons-png.flaticon.com/512/147/147144.png",
        ),
        UserModel(
          id: 2,
          username: "@FlutterDev",
          name: "Flutter Developer",
          profileImageUrl:
              "https://cdn-icons-png.flaticon.com/512/147/147140.png",
        ),
        UserModel(
          id: 3,
          username: "@yasser21233",
          name: "Yasser Ahmed",
          profileImageUrl:
              "https://cdn-icons-png.flaticon.com/512/147/147144.png",
        ),
        UserModel(
          id: 4,
          username: "@FlutterDev",
          name: "Flutter Developer",
          profileImageUrl:
              "https://cdn-icons-png.flaticon.com/512/147/147140.png",
        ),
        UserModel(
          id: 5,
          username: "@Mohamed",
          name: "Mohamed",
          profileImageUrl:
              "https://cdn-icons-png.flaticon.com/512/147/147144.png",
        ),
        UserModel(
          id: 6,
          username: "@FlutterDev",
          name: "Flutter Developer",
          profileImageUrl:
              "https://cdn-icons-png.flaticon.com/512/147/147140.png",
        ),
      ];

      final completions = [
        '$query tutorial',
        '$query example',
        '$query flutter',
      ];

      // Update state: preserve recents and controller
      state = AsyncData(
        prev.copyWith(
          suggestedAutocompletions: completions,
          suggestedUsers: mockUsers,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Add a term to the recent searched terms (most recent first, no duplicates)
  void addRecentTerm(String term) {
    final prev = state.value ?? SearchState();
    final updated = List<String>.from(prev.recentSearchedTerms!);
    updated.removeWhere((t) => t == term);
    updated.insert(0, term);
    state = AsyncData(prev.copyWith(recentSearchedTerms: updated));
  }

  // Add a recent profile (most recent first, no duplicates)
  void addRecentProfile(UserModel profile) {
    final prev = state.value ?? SearchState();
    final updated = List<UserModel>.from(prev.recentSearchedUsers!);
    updated.removeWhere((p) => p.id == profile.id);
    updated.insert(0, profile);
    state = AsyncData(prev.copyWith(recentSearchedUsers: updated));
  }

  // Select a recent term: put it in the controller and run search
  Future<void> selectRecentTerm(String term) async {
    final prev = state.value ?? SearchState();
    // update controller text (preserve controller instance)
    prev.searchController.text = term;
    // optionally move cursor to end
    prev.searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    // push the term into recents (moves it to top)
    addRecentTerm(term);
    // run search
    await search(term);
  }

  // Select a recent profile: put their display name into the search bar and add to recents
  Future<void> selectRecentProfile(UserModel profile) async {
    final prev = state.value ?? SearchState();
    prev.searchController.text = profile.name ?? profile.username ?? '';
    prev.searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: prev.searchController.text.length),
    );
    addRecentProfile(profile);
    // optionally search for that name
    await search(prev.searchController.text);
  }

  // Clear the search field and suggestions (keeps recents)
  void clearSearch() {
    final prev = state.value ?? SearchState();
    prev.searchController.clear();
    state = AsyncData(
      prev.copyWith(
        suggestedAutocompletions: const [],
        suggestedUsers: const [],
      ),
    );
  }
}
