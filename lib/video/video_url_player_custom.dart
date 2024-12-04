import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoUrlPlayerCustom extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  VideoUrlPlayerCustom({
    Key? key,
    required this.videoUrl,
    this.onNext,
    this.onPrevious,
  }) : super(key: key);

  @override
  _VideoUrlPlayerCustomState createState() => _VideoUrlPlayerCustomState();
}

class _VideoUrlPlayerCustomState extends State<VideoUrlPlayerCustom> {
  late VideoPlayerController _videoPlayerController;
  double _currentSliderValue = 0.0;
  late double _totalDuration;
  late String _formattedCurrentTime;
  late String _formattedTotalDuration;
  bool _isFullscreen = false; // 控制全屏状态
  bool _isInitialized = false; // 标识是否初始化完成

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _totalDuration = 0.0;
    _formattedCurrentTime = formatDuration(Duration.zero);
    _formattedTotalDuration = formatDuration(Duration.zero);
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();

    setState(() {
      _totalDuration = _videoPlayerController.value.duration.inSeconds.toDouble();
      _formattedTotalDuration = formatDuration(_videoPlayerController.value.duration);
      _isInitialized = true; // 初始化完成
    });

    _videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {
          _currentSliderValue = _videoPlayerController.value.position.inSeconds.toDouble();
          _formattedCurrentTime = formatDuration(_videoPlayerController.value.position);
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isFullscreen
            ? _buildFullscreenPlayer() // 横屏模式，进入全屏
            : _buildNormalPlayer(), // 竖屏模式
      ),
    );
  }

  // 竖屏下的视频播放器
  Widget _buildNormalPlayer() {
    return Column(
      children: [
        Container(
          height: 200, // 竖屏下固定高度
          child: _isInitialized
              ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          )
              : Center(child: CircularProgressIndicator()),
        ),
        _buildTimeDisplay(),
        _buildProgressBar(),
        _buildControlBar(),
      ],
    );
  }

  // 横屏下的视频播放器（全屏）
  Widget _buildFullscreenPlayer() {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          ),
        ),
        _buildTimeDisplay(),
        _buildProgressBar(),
        _buildControlBar(),
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formattedCurrentTime,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            _formattedTotalDuration,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    if (_totalDuration == 0.0) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slider(
        value: _currentSliderValue,
        min: 0.0,
        max: _totalDuration,
        onChanged: (value) {
          setState(() {
            _currentSliderValue = value;
            _videoPlayerController.seekTo(Duration(seconds: value.toInt()));
          });
        },
      ),
    );
  }

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: widget.onPrevious,
          ),
          Spacer(),
          IconButton(
            icon: Icon(_videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (_videoPlayerController.value.isPlaying) {
                _videoPlayerController.pause();
              } else {
                _videoPlayerController.play();
              }
            },
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: widget.onNext,
          ),
          Spacer(),
          IconButton(
            icon: Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
            onPressed: _toggleFullscreen, // 点击切换全屏
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '${hours == '00' ? '' : '$hours:'}$minutes:$seconds';
  }
}
