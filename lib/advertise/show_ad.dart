import 'dart:async';

import 'package:first_pe/advertise/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unionad/flutter_unionad.dart';
import 'package:provider/provider.dart';

import '../constant/InitStateModel.dart';
import 'banner_page.dart';
import 'drawfeed_page.dart';
import 'native_page.dart';

/// author lanxiong 
/// date 
/// describe：

class ShowAd extends StatefulWidget {
  const ShowAd({super.key});

  @override
  _ShowAdState createState() => _ShowAdState();
}

class _ShowAdState extends State<ShowAd> {
  //bool? _init;
  //String? _version;
  StreamSubscription? _adViewStream;
  int _themeStatus = FlutterUnionAdTheme.NIGHT;


  @override
  void initState() {
    super.initState();
    //_initRegister();
    _adViewStream = FlutterUnionadStream.initAdStream(
      flutterUnionadFullVideoCallBack: FlutterUnionadFullVideoCallBack(
        onShow: () {
          print("全屏广告显示");
        },
        onSkip: () {
          print("全屏广告跳过");
        },
        onClick: () {
          print("全屏广告点击");
        },
        onFinish: () {
          print("全屏广告结束");
        },
        onFail: (error) {
          print("全屏广告错误 $error");
        },
        onClose: () {
          print("全屏广告关闭");
        },
      ),
      //插屏广告回调
      flutterUnionadInteractionCallBack: FlutterUnionadInteractionCallBack(
        onShow: () {
          print("插屏广告展示");
        },
        onClose: () {
          print("插屏广告关闭");
        },
        onFail: (error) {
          print("插屏广告失败 $error");
        },
        onClick: () {
          print("插屏广告点击");
        },
        onDislike: (message) {
          print("插屏广告不喜欢  $message");
        },
      ),
      // 新模板渲染插屏广告回调
      flutterUnionadNewInteractionCallBack:
      FlutterUnionadNewInteractionCallBack(
        onShow: () {
          print("新模板渲染插屏广告显示");
        },
        onSkip: () {
          print("新模板渲染插屏广告跳过");
        },
        onClick: () {
          print("新模板渲染插屏广告点击");
        },
        onFinish: () {
          print("新模板渲染插屏广告结束");
        },
        onFail: (error) {
          print("新模板渲染插屏广告错误 $error");
        },
        onClose: () {
          print("新模板渲染插屏广告关闭");
        },
        onReady: () async {
          print("新模板渲染插屏广告预加载准备就绪");
          //显示新模板渲染插屏
          await FlutterUnionad.showFullScreenVideoAdInteraction();
        },
        onUnReady: () {
          print("新模板渲染插屏广告预加载未准备就绪");
        },
      ),
      //激励广告
      flutterUnionadRewardAdCallBack: FlutterUnionadRewardAdCallBack(
          onShow: () {
            print("激励广告显示");
          }, onClick: () {
        print("激励广告点击");
      }, onFail: (error) {
        print("激励广告失败 $error");
      }, onClose: () {
        print("激励广告关闭");
      }, onSkip: () {
        print("激励广告跳过");
      }, onReady: () async {
        print("激励广告预加载准备就绪");
        await FlutterUnionad.showRewardVideoAd();
      }, onCache: () async {
        print("激励广告物料缓存成功。建议在这里进行广告展示，可保证播放流畅和展示流畅，用户体验更好。");
      }, onUnReady: () {
        print("激励广告预加载未准备就绪");
      }, onVerify: (rewardVerify, rewardAmount, rewardName, errorCode, error) {
        print(
            "激励广告奖励  验证结果=$rewardVerify 奖励=$rewardAmount  奖励名称$rewardName 错误码=$errorCode 错误$error");
      }, onRewardArrived: (rewardVerify, rewardType, rewardAmount, rewardName,
          errorCode, error, propose) {
        print(
            "阶段激励广告奖励  验证结果=$rewardVerify 奖励类型<FlutterUnionadRewardType>=$rewardType 奖励=$rewardAmount"
                "奖励名称$rewardName 错误码=$errorCode 错误$error 建议奖励$propose");
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<InitStateModel>(context).isInit == null) {
      return Scaffold(
        body: Center(
          child: Text("正在进行穿山甲sdk初始化..."),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyAd example app'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: false,
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text("穿山甲初始化>>>>>> ${Provider.of<InitStateModel>(context).isInit ? "成功" : "失败"}"),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text("穿山甲SDK版本号>>>>>> v${Provider.of<InitStateModel>(context).version}"),
            ),
            //请求权限
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('请求权限'),
              onPressed: () async {
                FlutterUnionad.requestPermissionIfNecessary(
                  callBack: FlutterUnionadPermissionCallBack(
                    notDetermined: () {
                      print("权限未确定");
                    },
                    restricted: () {
                      print("权限限制");
                    },
                    denied: () {
                      print("权限拒绝");
                    },
                    authorized: () {
                      print("权限同意");
                    },
                  ),
                );
              },
            ),
            //切换主题
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('切换主题'),
              onPressed: () async {
                _themeStatus = _themeStatus == FlutterUnionAdTheme.DAY
                    ? FlutterUnionAdTheme.NIGHT
                    : FlutterUnionAdTheme.DAY;
                //_initRegister();
              },
            ),
            //banner广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('banner广告'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new BannerPage(),
                  ),
                );
              },
            ),
            //开屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('开屏广告'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new SplashPage(),
                  ),
                );
              },
            ),
            //个性化模板信息流广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('信息流广告'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new NativeAdPage(),
                  ),
                );
              },
            ),
            //激励视频
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('激励视频'),
              onPressed: () {
                FlutterUnionad.loadRewardVideoAd(
                  //是否个性化 选填
                  androidCodeId: "969029402",
                  //Android 激励视频广告id  必填
                  iosCodeId: "969029402",
                  ohosCodeId: '969029402',
                  //ios 激励视频广告id  必填
                  rewardName: "200金币",
                  //奖励名称 选填
                  rewardAmount: 200,
                  //奖励数量 选填
                  userID: "123",
                  //  用户id 选填
                  orientation: FlutterUnionadOrientation.VERTICAL,
                  //视屏方向 选填
                  mediaExtra: null,
                  //扩展参数 选填
                );
              },
            ),
            //个性化模板draw广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('draw视频广告'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new DrawFeedPage(),
                  ),
                );
              },
            ),
            //新模板渲染插屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('新模板渲染插屏广告'),
              onPressed: () {
                FlutterUnionad.loadFullScreenVideoAdInteraction(
                  //android 全屏广告id 必填
                  androidCodeId: "968460474",
                  //ios 全屏广告id 必填
                  iosCodeId: "968460474",
                  ohosCodeId: "968460474",
                  //视屏方向 选填
                  orientation: FlutterUnionadOrientation.VERTICAL,
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    if (_adViewStream != null) {
      _adViewStream?.cancel();
    }
  }
}