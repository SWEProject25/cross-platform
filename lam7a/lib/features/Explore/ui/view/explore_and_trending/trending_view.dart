import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/trending_hashtag.dart';
import '../../widgets/hashtag_list_item.dart';

class TrendingView extends ConsumerWidget {
  final List<TrendingHashtag> trendingHashtags;

  const TrendingView({super.key, required this.trendingHashtags});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scrollbar(
      // 🔥 Fade-in / fade-out effect (default behavior)
      interactive: true,
      radius: const Radius.circular(20),
      thickness: 6,

      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: trendingHashtags.length,
        itemBuilder: (context, index) {
          final hashtag = trendingHashtags[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: HashtagItem(hashtag: hashtag),
          );
        },
      ),
    );
  }
}
