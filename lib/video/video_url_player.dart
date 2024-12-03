import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoUrlPlayer extends StatefulWidget {
  final String videoUrl;

  VideoUrlPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoUrlPlayer> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((onError) {
        print("Error initializing video: $onError");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          setState(() {
            _isFullScreen = !_isFullScreen;
            if (_isFullScreen) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            } else {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
            }
          });
        },
        child: Stack(
          children: <Widget>[
            _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : Container(),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(_controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.fast_rewind),
                        onPressed: () {
                          final position = _controller.value.position - Duration(seconds: 10);
                          _controller.seekTo(position);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.fast_forward),
                        onPressed: () {
                          final position = _controller.value.position + Duration(seconds: 10);
                          _controller.seekTo(position);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.fullscreen),
                        onPressed: () {
                          setState(() {
                            _isFullScreen = !_isFullScreen;
                            if (_isFullScreen) {
                              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                            } else {
                              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                                  overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Slider(
                    value: _controller.value.position.inMilliseconds.toDouble(),
                    min: 0.0,
                    max: _controller.value.duration.inMilliseconds.toDouble(),
                    onChanged: (double value) {
                      _controller.seekTo(Duration(milliseconds: value.toInt()));
                    },
                    onChangeEnd: (double value) {
                      // 确保在滑动结束时也更新状态
                      setState(() {
                        _controller.seekTo(Duration(milliseconds: value.toInt()));
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(formatDuration(_controller.value.position)),
                        Text(formatDuration(_controller.value.duration)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}