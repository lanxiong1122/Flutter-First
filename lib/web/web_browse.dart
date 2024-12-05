import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert'; // 确保导入此包

class WebBrowse extends StatefulWidget {
  final String? htmlAssetPath; // 可选的本地HTML资产路径
  final String? url; // 可选的URL

  WebBrowse({this.htmlAssetPath, this.url}) : assert(htmlAssetPath != null || url != null);

  WebBrowse.fromArguments(Map<String, dynamic>? args)
      : htmlAssetPath = args?['htmlAssetPath'],
        url = args?['url'];

  @override
  _WebBrowseState createState() => _WebBrowseState();
}

class _WebBrowseState extends State<WebBrowse> {
  late WebViewController _controller;
  bool _isWebViewReady = false;
  String _pageTitle = 'Web Browse'; // 默认标题

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 设置状态栏和系统UI样式
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    });
  }

  // 初始化 WebView 控制器
  Future<void> _initializeWebViewController() async {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)  // 允许JavaScript
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print("WebBrowse-Page started loading: $url");
          },
          onPageFinished: (String url) async {
            String? title = await _controller.getTitle();
            setState(() {
              // 设置标题，超过10个字符则截断并添加省略号
              _pageTitle = (title?.length ?? 0) > 10 ? '${title!.substring(0, 10)}...' : title ?? 'No Title';
            });
            print("WebBrowse-Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            print("WebBrowse-Page resource error: ${error.description}");
          },
        ),
      )
      // 提供方法给js调用
      ..addJavaScriptChannel(
      'GoChannel',
      onMessageReceived: (JavaScriptMessage message) {
        print('WebBrowse-H5传来的消息: ${message.message}');
      try {
        // 解析 JSON 字符串为 Map
        final data = jsonDecode(message.message);
        // 检查是否包含 methodName 和 args 属性
        if (data['methodName'] != null) {
          final String methodName = data['methodName'];
          final args = data['args'];
          // 打印接收到的方法名和参数
          print('Received method name: $methodName');
          if (args != null) {
            print('Received arguments: $args');
          }
            // 根据 methodName 执行不同的逻辑
            if (methodName == 'openMap') {
              ScaffoldMessenger.of(context).showSnackBar(
                //SnackBar(content: Text(args['message'] ?? 'No message provided')),
                SnackBar(content: Text(args ?? 'No message provided')),
              );
            } else if (methodName == 'someOtherFunction') {
              // 处理其他方法...
              print('Executing someOtherFunction without arguments.');
            }
        } else {
          print('方法名空');
        }
      } catch (e) {
        print('Error parsing JSON from JS: $e');
        // 非json消息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message ?? '无值')),
        );
      }
    },
      );

    if (widget.url != null) {
      // 加载远程 URL
      await controller.loadRequest(Uri.parse(widget.url!));
    } else if (widget.htmlAssetPath != null) {
      // 加载本地 HTML 资产
      try {
        String htmlContent = await rootBundle.loadString(widget.htmlAssetPath!);
        await controller.loadHtmlString(htmlContent, baseUrl: 'about:blank');
        setState(() {
          _controller = controller;
          _isWebViewReady = true;
        });
      } catch (e) {
        print('Failed to load asset: ${widget.htmlAssetPath}');
      }

    }

    setState(() {
      _controller = controller;
      _isWebViewReady = true;
    });
  }

  // 拦截返回操作
  Future<bool> _onWillPop() async {
    bool canGoBack = await _controller.canGoBack();
    if (canGoBack) {
      await _controller.goBack();
      return false; // 阻止默认的返回操作
    }
    return true; // 如果没有历史记录，允许退出当前页面
  }

  // 显示更多操作菜单
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.refresh),
                title: Text('刷新'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (_isWebViewReady) {
                    _controller.reload(); // 刷新当前页面
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('分享'),
                onTap: () {
                  Navigator.of(context).pop();
                  // 这里你可以实现分享逻辑
                  print("WebBrowse-分享按钮被点击");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("分享")),
                  );
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
    return WillPopScope(
      onWillPop: _onWillPop, // 拦截返回操作
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // 自定义顶部栏
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 60,
                color: Colors.white,
                child: Row(
                  children: [
                    // 左侧返回按钮
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () async {
                        bool canGoBack = await _controller.canGoBack();
                        if (canGoBack) {
                          await _controller.goBack();
                        } else {
                          Navigator.of(context).pop(); // 关闭当前页面
                        }
                      },
                    ),
                    // 关闭按钮
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop(); // 关闭当前页面
                      },
                    ),
                    // 中间显示标题
                    Expanded(
                      child: Center(
                        child: Text(
                          _pageTitle, // 动态显示标题
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    // 右侧发送按钮，flutter调用js方法
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.black),
                      onPressed: () {
                        if (_isWebViewReady) {
                          // 方法一：发送消息到 JavaScript
                          /*_controller.runJavaScriptReturningResult('''
                            window.postMessage('Hello from Flutter!', '*');
                          ''').then((result) {
                            print("WebBrowse-Sent message to WebView: Hello from Flutter!');
                          }).catchError((error) {
                            print("WebBrowse-Failed to send message to WebView: $error');
                          });*/

                          // 方法二：调用js的showCustomAlert方法，可有参数和无参数
                          //callJsFunction('showCustomAlert');
                          // 创建一个包含多个字段的 Map
                          final Map<String, dynamic> alertParams = {
                            'message': 'Hello from Flutter!',
                            'timestamp': DateTime.now().toIso8601String(),
                            'additionalInfo': 'This is some extra information.'
                          };
                          callJsFunction('showCustomAlert', params: alertParams);
                        }
                      },
                    ),
                    // 右侧更多按钮
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.black),
                      onPressed: _showMoreOptions, // 点击更多按钮弹出操作菜单
                    ),
                  ],
                ),
              ),
              // WebView 内容部分
              _isWebViewReady
                  ? Expanded(child: WebViewWidget(controller: _controller))
                  : Center(child: CircularProgressIndicator()), // 显示加载指示器
            ],
          ),
        ),
      ),
    );
  }

  // flutter调用js
  void callJsFunction(String jsMethodName, {Map<String, dynamic>? params}) async {
    print('WebBrowse-调用js的方法及参数: $jsMethodName-------params：$params');
    if (_isWebViewReady && _controller != null) {
      String jsCode;

      if (params != null && params.isNotEmpty) {
        // 将 Dart Map 转换为 JSON 字符串，并确保它被正确转义
        final String jsonString = jsonEncode(params);

        // 对 JSON 字符串进行额外的转义以防止 JavaScript 错误
        final escapedJsonString = jsonString.replaceAll(r"'", r"\\'");

        // 构建 JavaScript 函数调用字符串，并确保 JSON 字符串被单引号包裹
        jsCode = '$jsMethodName(\'$escapedJsonString\');';
      } else {
        // 如果没有参数，则直接调用函数
        jsCode = '$jsMethodName();';
      }

      print('WebBrowse-Executing JS: $jsCode');
      await _controller.runJavaScript(jsCode);
    } else {
      print('WebBrowse-WebView is not ready or controller is not available.');
    }
  }
}
