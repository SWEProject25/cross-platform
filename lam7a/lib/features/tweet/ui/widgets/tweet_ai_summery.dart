import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'tweet_body_summary_widget.dart';
import '../viewmodel/tweet_viewmodel.dart';

///  FutureProvider → Fetches summary when page opens
class TweetAiSummery extends ConsumerStatefulWidget {
  final TweetModel tweet;

  const TweetAiSummery({super.key, required this.tweet});

  @override
  ConsumerState<TweetAiSummery> createState() => _TweetAiSummeryState();
}

class _TweetAiSummeryState extends ConsumerState<TweetAiSummery> {
  String? summary;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();

    // Call after first build (same behaviour as FutureProvider)
    Future.microtask(() async {
      try {
        final vm = ref.read(tweetViewModelProvider(widget.tweet.id).notifier);
        final String result = await vm.getSummary(widget.tweet.id);

        if (mounted) {
          setState(() {
            summary = result;
            loading = false;
          });
        }
      } catch (e) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("AI Summary"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: Colors.grey),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OriginalTweetCard(tweet: widget.tweet),
            const SizedBox(height: 16),

            Expanded(
              child: () {
                if (loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                }

                if (error != null) {
                  return Center(
                    child: Text(
                      "Failed to load summary.\n$error",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Text(
                    summary ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                );
              }(),
            ),
          ],
        ),
      ),
    );
  }
}
