import 'package:flutter/material.dart';
import '../../model/trending_hashtag.dart';
import '../../util/counter.dart';

class HashtagItem extends StatelessWidget {
  final TrendingHashtag hashtag;

  const HashtagItem({super.key, required this.hashtag});

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
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.only(top: 0, bottom: 0, left: 12, right: 0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
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
                  if (hashtag.order != null)
                    Text(
                      '${hashtag.order}. Trending in Egypt',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    textAlign: TextAlign.center,
                    hashtag.hashtag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // const SizedBox(height: 2),
                  if (hashtag.tweetsCount != null)
                    Text(
                      '${CounterFormatter.format(hashtag.tweetsCount!)} posts',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                ],
              ),
            ),
          ),

          // Three-dots button
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _showBottomOptions(context),
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF202328),
                  size: 18,
                ),
              ),
            ],

            // constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
