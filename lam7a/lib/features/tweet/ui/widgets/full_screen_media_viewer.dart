import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';

class FullScreenMediaViewer extends StatelessWidget {
  final String url;
  final bool isVideo;

  const FullScreenMediaViewer({
    super.key,
    required this.url,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: isVideo
                  ? VideoPlayerWidget(url: url)
                  : InteractiveViewer(
                      child: Image.network(
                        url,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 48,
                          );
                        },
                      ),
                    ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
