import 'package:flutter/material.dart';


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
    const Center(child: Text('Tab 1 Content',style: TextStyle(fontSize: 50,color: Colors.green),)),
    const Center(child: Text('Tab 2 Content')),
    const Center(child: Text('Tab 3 Content')),
    const Center(child: Text('Tab 4 Content',style: TextStyle(fontSize: 35,color: Colors.blue),)),
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
            label: 'Night Life',
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