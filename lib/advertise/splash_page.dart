import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:provider/provider.dart';
import '../constant/InitStateModel.dart';
import 'package:flutter/foundation.dart';

/// 描述：开屏广告页

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool _offstage = true;

  @override
  void initState() {
    super.initState();
    _initRegister();
  }

  @override
  Widget build(BuildContext context) {
    // 检查是否为 Android 或 iOS 平台
    bool isAndroidOrIOS = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
    // 如果不是 Android 或 iOS 平台，在首次构建时执行跳转
    if (!isAndroidOrIOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
      // 返回一个空的 Container 或者加载指示器
      return Container();
    }
    // 如果是 Android 或 iOS 平台，根据广告初始化状态返回不同的 UI
    return Provider.of<InitStateModel>(context).isInit ? Column(
      children: [
        Offstage(
          offstage: _offstage,
          child: FlutterUnionadSplashAdView(
            androidCodeId: "102729400",
            iosCodeId: "102729400",
            supportDeepLink: true,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            hideSkip: false,
            timeout: 3000,
            callBack: FlutterUnionadSplashCallBack(
              onShow: () {
                print("开屏广告显示");
                setState(() => _offstage = false);
              },
              onClick: () {
                print("开屏广告点击");
              },
              onFail: (error) {
                print("开屏广告失败 $error");
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              onFinish: () {
                print("开屏广告倒计时结束");
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              onSkip: () {
                print("开屏广告跳过");
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              onTimeOut: () {
                print("开屏广告超时");
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
            ),
          ),
        ),
      ],
    ) : Center(
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Text("广告初始化中"),
      ),
    );
  }
  //初始化广告
  void _initRegister() async {
    bool init = await FlutterUnionad.register(
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
    print("sdk初始化 $init");
    String version = await FlutterUnionad.getSDKVersion();
    //_themeStatus = await FlutterUnionad.getThemeStatus();
    setState(() {});
    Provider.of<InitStateModel>(context, listen: false).setInit(init);
    Provider.of<InitStateModel>(context, listen: false).setVersion(version);
  }
}
