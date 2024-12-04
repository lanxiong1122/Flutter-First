import 'package:first_pe/home/tab/home_tab.dart';
import 'package:first_pe/home/tab/school_tab.dart';
import 'package:first_pe/setting/setting_page.dart';
import 'package:flutter/material.dart';
import '../video/video_url_player.dart';
import '../video/video_url_player_custom.dart';


class HomePage extends StatefulWidget {
   //const HomePage({Key? key, required this.title}) : super(key: key);
   const HomePage({super.key, required this.title});

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    //const Center(child: Text('Tab 1 Content',style: TextStyle(fontSize: 50,color: Colors.green),)),
    const HomeTab(),
    //const Center(child: Text('Tab 2 Content')),
    //const SchoolTab(),
    //VideoUrlPlayer(videoUrl: "https://media.w3.org/2010/05/sintel/trailer.mp4"),
    VideoUrlPlayer(videoUrl: "http://xcxx.daoran.tv/34638a271c9b47ebb5d10a6b04931b5b/011f2a8d55c9d75cccd559a9f2264efe-hd-nbv1.m3u8?auth_key=1733305003-54db7009bea849399998fde1dd99f420-0-04de969135f9bc1e015fce7a7ed456de"),
    VideoUrlPlayerCustom(videoUrl: "http://xcxx.daoran.tv/34638a271c9b47ebb5d10a6b04931b5b/011f2a8d55c9d75cccd559a9f2264efe-hd-nbv1.m3u8?auth_key=1733305003-54db7009bea849399998fde1dd99f420-0-04de969135f9bc1e015fce7a7ed456de"),
    //VideoUrlPlayerCustom(videoUrl: "https://media.w3.org/2010/05/sintel/trailer.mp4"),
    const SettingPage(),
    //const Center(child: Text('Tab 4 Content',style: TextStyle(fontSize: 35,color: Colors.blue),)),
  ];

  final PageController _pageController = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: PageView(
        controller: _pageController,
        //physics: const NeverScrollableScrollPhysics(),  // 禁止左后滑动
        onPageChanged: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlife),
            label: 'Mine',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // 选中的颜色
        unselectedItemColor: Colors.black, // 未选中的图标颜色
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true, // 显示未选中的标签
        unselectedLabelStyle: TextStyle(color: Colors.black), // 未选中的标签颜色
        onTap: _onItemTapped,
      ),
    );
  }
}