import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
/// 自定义Chewie播放器
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
  bool _isFullscreen = false;
  bool _isPlaying = false;
  double _currentSliderValue = 0.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();

    _videoPlayerController.play();
    _isPlaying = true;

    _videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {
          _currentSliderValue = _videoPlayerController.value.position.inSeconds.toDouble();
        });
      }
    });

    setState(() {});
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
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    }
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _videoPlayerController.setPlaybackSpeed(speed);
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
        _isPlaying = false;
      } else {
        _videoPlayerController.play();
        _isPlaying = true;
      }
    });
  }

  void _showSpeedControlPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("选择操作"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("倍速"),
                onTap: () {
                  Navigator.pop(context);
                  _showSpeedSelectionDialog();
                },
              ),
              ListTile(
                title: Text("取消"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSpeedSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("选择播放速度"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (double speed in [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0])
                ListTile(
                  title: Text('${speed}x'),
                  onTap: () {
                    _changePlaybackSpeed(speed);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // 设置状态栏颜色为透明
        statusBarIconBrightness: Brightness.light, // 设置状态栏图标颜色（白色）
        systemNavigationBarColor: Colors.transparent, // 设置底部导航栏颜色（如果需要）
        systemNavigationBarIconBrightness: Brightness.light, // 设置底部导航栏图标颜色（如果需要）
      ),
      child: Scaffold(
        body: !_videoPlayerController.value.isInitialized
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
          child: _isFullscreen
              ? _buildFullscreenPlayer()
              : _buildPortraitPlayer(),
        ),
      ),
    );
  }

  // 竖屏播放器布局（高度为200）
  Widget _buildPortraitPlayer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Stack(
        children: [
          // 视频播放器底层，设置固定高度
          Positioned(
            top: 0,
            left: 0,
            right: 0,
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
            ),
          ),
          // 时间显示，位于进度条上方
          Positioned(
            bottom: 38,
            left: 20,
            child: _buildTimeDisplay(),
          ),
          // 进度条，位于视频下方
          Positioned(
            bottom: 10, // 这里调整了底部位置，避免与控制栏重叠
            left: 1,
            right: 30,
            child: _buildProgressBar(),
          ),
          // 播放控制按钮（居中）
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: _buildControlBar(),
          ),
          // 全屏按钮（右下角）
          Positioned(
            bottom: 0,
            right: 5,
            child: _buildFullscreenButton(),
          ),
          // 右上角倍速选择按钮（三个点）
          Positioned(
            top: 10,
            right: 1,
            child: _buildSpeedControlButton(),
          ),
        ],
      ),
    );
  }

  // 全屏播放器布局
  Widget _buildFullscreenPlayer() {
    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // 视频播放器填充整个屏幕
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
          // 时间显示
          Positioned(
            bottom: 50,
            left: 20,
            child: _buildTimeDisplay(),
          ),
          // 进度条
          Positioned(
            bottom: 20,
            left: 5,
            right: 30,
            child: _buildProgressBar(),
          ),
          // 播放控制按钮（居中）
          Positioned(
            bottom: MediaQuery.of(context).size.height/2,
            left: 0,
            right: 0,
            child: _buildControlBar(),
          ),
          // 全屏按钮（右下角）
          Positioned(
            bottom: 5,
            right: 5,
            child: _buildFullscreenButton(),
          ),
          // 右上角倍速选择按钮（三个点）
          Positioned(
            top: 10,
            right: 5,
            child: _buildSpeedControlButton(),
          ),
        ],
      ),
    );
  }

  // 时间显示
  Widget _buildTimeDisplay() {
    final totalDuration = _videoPlayerController.value.duration;
    final currentDuration = _videoPlayerController.value.position;
    return Text(
      '${_formatDuration(currentDuration)} / ${_formatDuration(totalDuration)}',
      style: TextStyle(color: Colors.white, fontSize: 12),
    );
  }

  // 格式化时间
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // 进度条
  Widget _buildProgressBar() {
    final totalDuration = _videoPlayerController.value.duration.inSeconds.toDouble();
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0), // 设置滑块的半径
        overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0), // 设置滑块覆盖层的半径
      ),
      child: Slider(
        value: _currentSliderValue,
        min: 0.0,
        max: totalDuration,
        onChanged: (value) {
          setState(() {
            _currentSliderValue = value;
            _videoPlayerController.seekTo(Duration(seconds: value.toInt()));
          });
        },
        thumbColor: Colors.white,
        activeColor: Colors.blue,
        inactiveColor: Colors.blue.shade100,
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.3)),
      ),
    );
  }

  // 控制栏：播放/暂停、上一首、下一首按钮
  Widget _buildControlBar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.skip_previous, color: Colors.white),
            onPressed: widget.onPrevious,
          ),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: Icon(Icons.skip_next, color: Colors.white),
            onPressed: widget.onNext,
          ),
        ],
      ),
    );
  }

  // 全屏按钮（右下角）
  Widget _buildFullscreenButton() {
    return IconButton(
      icon: Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white),
      onPressed: _toggleFullscreen,
    );
  }

  // 右上角倍速选择按钮（三个点）
  Widget _buildSpeedControlButton() {
    return IconButton(
      icon: Icon(Icons.more_vert, color: Colors.white),
      onPressed: _showSpeedControlPopup,
    );
  }
}
