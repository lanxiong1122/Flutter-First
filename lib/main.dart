import 'package:first_pe/home/home_page.dart';
import 'package:first_pe/login/login_page.dart';
import 'package:first_pe/setting/setting_page.dart';
import 'package:first_pe/web/web_browse.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
      ),
      //home: HomePage(title: 'Flutter Bottom Navigation with PageView'),
      initialRoute: '/',
      routes: {
          '/login': (context) => const LoginPage(),
          '/':(context) => const HomePage(title: "Flutter Bottom Navigation with PageView"),
          '/setting': (context) => const SettingPage(),
          '/webview': (context) => WebBrowse.fromArguments(ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?),
      },
    );
  }
}

