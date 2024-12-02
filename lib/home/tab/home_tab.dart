import 'package:flutter/material.dart';
import 'dart:async';

class ItemBean {
  final String title;
  final String imageUrl;

  ItemBean(this.title, this.imageUrl);
}

List<ItemBean> _items = [
  ItemBean('Item 1', 'https://img2.baidu.com/it/u=3402688989,1564419070&fm=253&fmt=auto&app=138&f=JPEG?w=1140&h=641'),
  ItemBean('Item 2', 'https://img2.baidu.com/it/u=379661729,419280021&fm=253&fmt=auto&app=138&f=JPEG?w=803&h=500'),
  ItemBean('Item 3', 'https://img2.baidu.com/it/u=286024229,2201233556&fm=253&fmt=auto&app=138&f=JPEG?w=400&h=282'),
  ItemBean('Item 4', 'https://img0.baidu.com/it/u=2801517654,3834935619&fm=253&fmt=auto&app=138&f=JPEG?w=499&h=333')
  // 添加更多的item...
];

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  final PageController _controller = PageController(initialPage: 0);
  int _currentIndex = 0;
  late Timer _timer; // 定时器

  @override
  void initState() {
    super.initState();
    _startTimer(); // 启动定时器
  }

  @override
  void dispose() {
    _timer.cancel(); // 取消定时器
    super.dispose();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 3); // 每3秒切换一次
    _timer = Timer.periodic(
      oneSecond, (Timer timer) {
        if (_currentIndex < _items.length - 1) {
          _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        } else {
          // 当前是最后一个item时，直接跳转到第一页
          _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Tab')),
      body: Column(
        children: <Widget>[
          // 轮播图部分
          Container(
            height: 200,
            child: PageView.builder(
              controller: _controller,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0), // 左右间距
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0), // 圆角
                    child: Image.network(
                      _items[index].imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          // 指示器
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_items.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: _currentIndex == index ? 8 : 6, // 当前页的指示器稍微大一点
                  height: _currentIndex == index ? 8 : 6, // 确保宽度和高度相等
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.amber : Colors.grey,
                    borderRadius: BorderRadius.circular(8), // 圆角半径与宽高相同
                  ),
                ),
              );
            }),
          ),
          // 底部两列布局部分
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Item $index'),
                      );
                    },
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Item $index'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}