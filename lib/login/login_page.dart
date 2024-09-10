import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';


class LoginPage extends StatefulWidget {
  //const LoginPage({Key? key}) : super(key: key);
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _appName  = '登录';

    @override
    void initState() {
        super.initState();
        _fetchAppName();
    }

    Future<void> _fetchAppName() async {
        WidgetsFlutterBinding.ensureInitialized();
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        // String appName = packageInfo.appName;
        // String packageName = packageInfo.packageName;
        // String version = packageInfo.version;
        // String buildNumber = packageInfo.buildNumber;
        setState(() {
            _appName = packageInfo.appName;
          });
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                  decoration: InputDecoration(
                    labelText: '用户名',
                    labelStyle: const TextStyle(fontSize: 16, color: Color(0xFF309333)),
                    //hintText: '用户名',
                    //hintStyle: const TextStyle(fontSize: 16, color: Color(0xFF309333)),
                    filled: true, // 设置 filled 为 true 并指定 fillColor 为淡蓝色背景
                    fillColor: Colors.blue.withOpacity(0.2), // 蓝色背景
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // 圆角
                      borderSide: BorderSide.none, // 默认无边框
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // 圆角
                      borderSide: const BorderSide(color: Colors.green, width: 2), // 聚焦时的绿色边框
                    ),
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入用户名';
                  }
                  return null;
                },
                onSaved: (value) =>{
                  if (value != null) {
                    _username = value,
                 }}
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '密码',
                  labelStyle: const TextStyle(fontSize: 16, color: Color(0xFF309333)),
                  //hintText: '用户名',
                  //hintStyle: const TextStyle(fontSize: 16, color: Color(0xFF309333)),
                  filled: true, // 设置 filled 为 true 并指定 fillColor 为淡蓝色背景
                  fillColor: Colors.blue.withOpacity(0.2), // 蓝色背景
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20), // 圆角
                    borderSide: BorderSide.none, // 默认无边框
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20), // 圆角
                    borderSide: const BorderSide(color: Colors.green, width: 2), // 聚焦时的绿色边框
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final formState = _formKey.currentState;
                    if (formState != null && formState.validate()) {
                      formState.save();
                      // 这里可以添加处理登录逻辑的地方
                      if (kDebugMode) {
                        print('用户名: $_username, 密码: $_password');
                      }
                      Navigator.pushReplacementNamed(context,'/home'); // 跳转到首页
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,  // 背景颜色
                      foregroundColor: Colors.orange, // 文本颜色,文本Text的优先
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // 圆角
                      elevation: 1  // 阴影深度
                  ),
                  child: const Text('登录',style: TextStyle(fontSize: 20,color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  // 这里可以跳转到注册页面
                  print('点击了注册');
                },
                child: const Text(
                  '还没有账号？立即注册',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}