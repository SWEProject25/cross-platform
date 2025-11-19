import 'package:flutter/widgets.dart';

import '../../../../core/models/user_model.dart';

class SearchState {
  final List<UserModel>? recentSearchedUsers;
  final List<String>? recentSearchedTerms;
  final TextEditingController searchController = TextEditingController();
  final List<String>? suggestedAutocompletions;
  final List<UserModel>? suggestedUsers;

  SearchState({
    this.recentSearchedUsers = const [],
    this.recentSearchedTerms = const [],
    this.suggestedAutocompletions = const [],
    this.suggestedUsers = const [],
  });

  SearchState copyWith({
    List<UserModel>? recentSearchedUsers,
    List<String>? recentSearchedTerms,
    List<String>? suggestedAutocompletions,
    List<UserModel>? suggestedUsers,
  }) {
    return SearchState(
      recentSearchedUsers: recentSearchedUsers ?? this.recentSearchedUsers,
      recentSearchedTerms: recentSearchedTerms ?? this.recentSearchedTerms,
      suggestedAutocompletions:
          suggestedAutocompletions ?? this.suggestedAutocompletions,
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
    );
  }
}
