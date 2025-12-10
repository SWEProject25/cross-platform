import 'package:flutter/material.dart';
import '../../model/trending_hashtag.dart';
import '../../util/counter.dart';
import '../view/search_result_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/search_results_viewmodel.dart';

class HashtagItem extends StatelessWidget {
  final TrendingHashtag hashtag;
  final bool showOrder;

  const HashtagItem({super.key, required this.hashtag, this.showOrder = true});

  void _showBottomOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: const Color.fromARGB(180, 36, 36, 36), // dim background
      backgroundColor: const Color(0xFF1A1A1A), // dark sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetOption(context, "This trend is spam"),
              _sheetOption(context, "Not interested in this"),
              _sheetOption(context, "This trend is abusive or harmful"),
            ],
          ),
        );
      },
    );
  }

  Widget _sheetOption(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // close bottom sheet
        // You can trigger VM logic here if needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        width: double.infinity,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior:
          HitTestBehavior.translucent, // <-- disables InkWell-like effects
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProviderScope(
              overrides: [
                searchResultsViewModelProvider.overrideWith(
                  () => SearchResultsViewmodel(),
                ),
              ],
              child: SearchResultPage(hintText: hashtag.hashtag),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 6, right: 0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Expanded text section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hashtag.order != null) ...[
                      Text(
                        '${showOrder ? "${hashtag.order}." : ''} Trending in Our App',
                        style: TextStyle(
                          color: theme.brightness == Brightness.light
                              ? const Color(0xFF52636d)
                              : const Color(0xFF7c838c),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else if (hashtag.trendCategory != null) ...[
                      Text(
                        'Trending in ${hashtag.trendCategory}',
                        style: TextStyle(
                          color: theme.brightness == Brightness.light
                              ? const Color(0xFF52636d)
                              : const Color(0xFF7c838c),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 1),

                    Text(
                      hashtag.hashtag,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.brightness == Brightness.light
                            ? const Color(0xFF0f1418)
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    if (hashtag.tweetsCount != null)
                      Text(
                        '${CounterFormatter.format(hashtag.tweetsCount!)} posts',
                        style: TextStyle(
                          color: theme.brightness == Brightness.light
                              ? const Color(0xFF52636d)
                              : const Color(0xFF7c838c),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
