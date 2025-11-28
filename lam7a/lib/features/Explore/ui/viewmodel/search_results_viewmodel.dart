import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/tweet_model.dart';
import '../../../../core/models/user_model.dart';
import '../state/search_result_state.dart';

final searchResultsViewModelProvider =
    AsyncNotifierProvider<SearchResultsViewmodel, SearchResultState>(() {
      return SearchResultsViewmodel();
    });

class SearchResultsViewmodel extends AsyncNotifier<SearchResultState> {
  final List<UserModel> _mockPeople = [
    UserModel(id: 1, username: "Ahmed"),
    UserModel(id: 2, username: "Mona"),
    UserModel(id: 3, username: "Sara"),
    UserModel(id: 4, username: "Kareem"),
    UserModel(id: 5, username: "Omar"),
  ];

  final _mockTweets = <String, TweetModel>{
    't1': TweetModel(
      id: 't1',
      userId: '1',
      body: 'This is a mocked tweet about Riverpod with multiple images!',
      likes: 23,
      repost: 4,
      comments: 3,
      views: 230,
      date: DateTime.now().subtract(const Duration(days: 1)),
      mediaImages: [
        'https://media.istockphoto.com/id/1703754111/photo/sunset-dramatic-sky-clouds.jpg?s=612x612&w=0&k=20&c=6vevvAvvqvu5MxfOC0qJuxLZXmus3hyUCfzVAy-yFPA=',
        'https://picsum.photos/seed/img1/800/600',
        'https://picsum.photos/seed/img2/800/600',
      ],
      mediaVideos: [],
      qoutes: 777000,
      bookmarks: 6000000,
    ),
    't2': TweetModel(
      id: 't2',
      userId: '2',
      body: 'Mock tweet #2 — Flutter is amazing with videos!',
      likes: 54,
      repost: 2,
      comments: 10,
      views: 980,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      mediaImages: [],
      mediaVideos: [
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ],
      qoutes: 1000000,
      bookmarks: 5000000000,
    ),
    't3': TweetModel(
      id: "t3",
      userId: "1",
      body: "Hi This Is The Tweet Body\nHappiness comes from within...",
      mediaImages: [
        'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
        'https://picsum.photos/seed/nature/800/600',
      ],
      mediaVideos: [
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ],
      date: DateTime.now().subtract(const Duration(days: 1)),
      likes: 999,
      comments: 8900,
      views: 5700000,
      repost: 54,
      qoutes: 9000000000,
      bookmarks: 10,
    ),
  };

  int _peopleIndex = 0;
  int _tweetIndex = 0;
  final int _batchSize = 2;

  @override
  Future<SearchResultState> build() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return SearchResultState(
      currentResultType: CurrentResultType.top,
      searchedPeople: _loadInitialPeople(),
      searchedTweets: _loadInitialTweets(),
    );
  }

  void selectTab(CurrentResultType type) {
    final prev = state.value!;
    state = AsyncData(prev.copyWith(currentResultType: type));
  }

  List<UserModel> _loadInitialPeople() {
    final end = (_peopleIndex + _batchSize).clamp(0, _mockPeople.length);
    final items = _mockPeople.sublist(_peopleIndex, end);
    _peopleIndex = end;
    return items;
  }

  List<TweetModel> _loadInitialTweets() {
    final end = (_tweetIndex + _batchSize).clamp(0, _mockTweets.length);
    final items = _mockTweets.values.toList().sublist(_tweetIndex, end);
    _tweetIndex = end;
    return items;
  }

  Future<void> loadMorePeople() async {
    final prev = state.value!;
    await Future.delayed(const Duration(milliseconds: 300));

    if (_peopleIndex >= _mockPeople.length) return;

    final end = (_peopleIndex + _batchSize).clamp(0, _mockPeople.length);
    final newItems = _mockPeople.sublist(_peopleIndex, end);
    _peopleIndex = end;

    state = AsyncData(
      prev.copyWith(searchedPeople: [...prev.searchedPeople, ...newItems]),
    );
  }

  Future<void> loadMoreTweets() async {
    final prev = state.value!;
    await Future.delayed(const Duration(milliseconds: 300));

    if (_tweetIndex >= _mockTweets.length) return;

    final end = (_tweetIndex + _batchSize).clamp(0, _mockTweets.length);
    final newItems = _mockTweets.values.toList().sublist(_tweetIndex, end);
    _tweetIndex = end;

    state = AsyncData(
      prev.copyWith(searchedTweets: [...prev.searchedTweets, ...newItems]),
    );
  }
}
