import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

final testUser = UserModel(
  id: 1,
  profileId: 1,
  username: 'hossam',
  name: 'Hossam',
);

PaginationState<TweetModel> emptyPagination() =>
    const PaginationState(items: [], hasMore: false, isLoading: false);

PaginationState<TweetModel> loadingPagination() =>
    const PaginationState(items: [], hasMore: false, isLoading: true);
