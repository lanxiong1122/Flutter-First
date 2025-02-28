import 'package:flutter/material.dart';

/// author lanxiong 
/// date 
/// describe：appbar联动

class AppBarEffective extends StatefulWidget {
  const AppBarEffective({super.key});

  @override
  _AppBarEffectiveState createState() => _AppBarEffectiveState();
}

class _AppBarEffectiveState extends State<AppBarEffective> {
  final List<Color> appBarColors = [Colors.blue, Colors.green, Colors.red];
  ScrollController scrollController = ScrollController();
  double maxScrollExtent = 50; // 定义最大滚动距离作为颜色变换的基础
  double searchBoxWidthPercent = 0.62; // 初始宽度比例

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double scrollPercent = (scrollController.offset / maxScrollExtent).clamp(0.0, 1.0);
      int newIndex = (scrollPercent * (appBarColors.length - 1)).round();

      setState(() {
        searchBoxWidthPercent = 0.62 - scrollPercent * 0.18; // 根据需求调整公式
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: searchBoxWidthPercent > 0.6 ? const Icon(Icons.menu, color: Colors.white) : const Text(''),
              title: InkWell(
                onTap: () {
                  // Navigate to search page
                },
                child: AnimatedContainer(
                  width: MediaQuery.of(context).size.width * searchBoxWidthPercent,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(246, 246, 246, 1),
                      borderRadius: BorderRadius.circular(30)),
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: searchBoxWidthPercent > 0.6 ? 10 : 5),
                        child: const Icon(Icons.search, color: Colors.black54),
                      ),
                      const Text('手机', style: TextStyle(color: Colors.black54, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue, // Use dynamic colors based on scroll if needed
              elevation: 0,
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code), color: Colors.white),
                IconButton(onPressed: () {}, icon: const Icon(Icons.message), color: Colors.white),
              ],
              expandedHeight: maxScrollExtent,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(color: appBarColors[searchBoxWidthPercent > 0.6 ?0:1]), // Use dynamic colors based on scroll if needed
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 300,
          itemBuilder: (context, index) {
            return ListTile(title: Text("Item $index"));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}