import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: ValueKey('video-player-${widget.url}'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (!_controller.value.isInitialized) return;
        if (info.visibleFraction <= 0) {
          if (_controller.value.isPlaying) {
            _controller.pause();
          }
        } else {
          if (!_controller.value.isPlaying) {
            _controller.play();
          }
        }
      },
      child: FutureBuilder<void>(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(children: [
                    VideoPlayer(_controller),

                  Center(
                    child:  _controller.value.isPlaying ? IconButton(onPressed: () {
                      _controller.pause();
                      setState(() {
                        
                      });
                    }, icon: Icon(Icons.pause, color: Colors.white54, size: 50,)) : IconButton(onPressed: () {
                      _controller.play();
                      setState(() {
                        
                      });
                    }, icon: Icon(Icons.play_arrow, color: Colors.white54, size: 50,)
                    )),
                ],),
              ),
            );
          } else {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey.shade800,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
