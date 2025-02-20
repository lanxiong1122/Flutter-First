import 'package:first_pe/advertise/show_ad.dart';
import 'package:first_pe/home/tab/home_tab.dart';
import 'package:first_pe/home/tab/school_tab.dart';
import 'package:first_pe/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:provider/provider.dart';
import '../advertise/show_ad.dart';
import '../constant/InitStateModel.dart';
import '../video/video_url_player.dart';
import '../video/video_url_player_custom.dart';

// 主页  多个tab
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
    const ShowAd(),
    //VideoUrlPlayer(videoUrl: "https://media.w3.org/2010/05/sintel/trailer.mp4"),
    VideoUrlPlayerCustom(videoUrl: "https://media.w3.org/2010/05/sintel/trailer.mp4"),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _initRegister();
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
  //注册
  void _initRegister() async {
    bool _init = await FlutterUnionad.register(
      //穿山甲广告 Android appid 必填
        androidAppId: "5098580",
        //穿山甲广告 ios appid 必填
        iosAppId: "5098580",
        ohosAppId: "5638354",
        //appname 必填
        appName: "unionad_test",
        //使用聚合功能一定要打开此开关，否则不会请求聚合广告，默认这个值为false
        //true使用GroMore下的广告位
        //false使用广告变现下的广告位
        useMediation: true,
        //是否为计费用户 选填
        paid: false,
        //用户画像的关键词列表 选填
        keywords: "",
        //是否允许sdk展示通知栏提示 选填
        allowShowNotify: true,
        //是否显示debug日志
        debug: true,
        //是否支持多进程 选填
        supportMultiProcess: false,
        //主题模式 默认FlutterUnionAdTheme.DAY,修改后需重新调用初始化
        //themeStatus: _themeStatus,
        //允许直接下载的网络状态集合 选填
        directDownloadNetworkType: [
          FlutterUnionadNetCode.NETWORK_STATE_2G,
          FlutterUnionadNetCode.NETWORK_STATE_3G,
          FlutterUnionadNetCode.NETWORK_STATE_4G,
          FlutterUnionadNetCode.NETWORK_STATE_WIFI
        ],
        androidPrivacy: AndroidPrivacy(
          //是否允许SDK主动使用地理位置信息 true可以获取，false禁止获取。默认为true
          isCanUseLocation: false,
          //当isCanUseLocation=false时，可传入地理位置信息，穿山甲sdk使用您传入的地理位置信息lat
          lat: 0.0,
          //当isCanUseLocation=false时，可传入地理位置信息，穿山甲sdk使用您传入的地理位置信息lon
          lon: 0.0,
          // 是否允许SDK主动使用手机硬件参数，如：imei
          isCanUsePhoneState: false,
          //当isCanUsePhoneState=false时，可传入imei信息，穿山甲sdk使用您传入的imei信息
          imei: "",
          // 是否允许SDK主动使用ACCESS_WIFI_STATE权限
          isCanUseWifiState: false,
          // 当isCanUseWifiState=false时，可传入Mac地址信息
          macAddress: "",
          // 是否允许SDK主动使用WRITE_EXTERNAL_STORAGE权限
          isCanUseWriteExternal: false,
          // 开发者可以传入oaid
          oaid: "b69cd3cf68900323",
          // 是否允许SDK主动获取设备上应用安装列表的采集权限
          alist: false,
          // 是否能获取android ID
          isCanUseAndroidId: false,
          // 开发者可以传入android ID
          androidId: "",
          // 是否允许SDK在申明和授权了的情况下使用录音权限
          isCanUsePermissionRecordAudio: false,
          // 是否限制个性化推荐接口
          isLimitPersonalAds: false,
          // 是否启用程序化广告推荐 true启用 false不启用
          isProgrammaticRecommend: false,
        ),
        iosPrivacy: IOSPrivacy(
          //允许个性化广告
          limitPersonalAds: false,
          //允许程序化广告
          limitProgrammaticAds: false,
          //允许CAID
          forbiddenCAID: false,
        ));
    print("sdk初始化 $_init");
    String _version = await FlutterUnionad.getSDKVersion();
    //_themeStatus = await FlutterUnionad.getThemeStatus();
    setState(() {});
    Provider.of<InitStateModel>(context, listen: false).setInit(_init);
    Provider.of<InitStateModel>(context, listen: false).setVersion(_version);
  }
}