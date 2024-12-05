import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart'; // 导入这个包以使用 SystemChrome
/// 直接使用Chewie播放器，无自定义
class VideoUrlPlayer extends StatefulWidget {
  final String videoUrl;

  VideoUrlPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoUrlPlayerState createState() => _VideoUrlPlayerState();
}

class _VideoUrlPlayerState extends State<VideoUrlPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    // 全局设置状态栏样式
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, // 设置状态栏颜色为透明
    //   statusBarIconBrightness: Brightness.light, // 设置状态栏图标颜色（白色）
    //   systemNavigationBarColor: Colors.black, // 设置底部导航栏颜色（如果需要）
    //   systemNavigationBarIconBrightness: Brightness.light, // 设置底部导航栏图标颜色（如果需要）
    // ));

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true, // 允许全屏
      allowedScreenSleep: false, // 防止屏幕休眠
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue, // 更鲜艳的红色表示已播放部分
        handleColor: Colors.white,     // 白色的手柄
        backgroundColor: Colors.grey.shade300, // 浅灰色的背景色
        bufferedColor: Colors.blue.shade100,   // 淡蓝色表示缓冲部分
      ),
      placeholder: Container(
        color: Colors.black,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

    if (mounted) { // 检查 widget 是否仍然挂载
      setState(() {});
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 设置状态栏颜色为透明
        statusBarIconBrightness: Brightness.light, // 设置状态栏图标颜色（白色）
        systemNavigationBarColor: Colors.transparent, // 设置底部导航栏颜色（如果需要）
        //systemNavigationBarIconBrightness: Brightness.light, // 设置底部导航栏图标颜色（如果需要）
      ),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(height: MediaQuery.of(context).padding.top,color: Colors.black), // 确保状态栏有空间
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200, // 设置播放器高度为200
              child: _videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading...'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}