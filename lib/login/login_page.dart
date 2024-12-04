//import 'package:first_pe/home/home_page.dart';
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
  final TextEditingController _passwordController = TextEditingController();

    @override
    void initState() {
        super.initState();
        _fetchAppName();
        _passwordController.addListener(() {
          // 当文本变化时，调用 setState 来重新构建
          setState(() {});
        });
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
                    labelStyle: const TextStyle(fontSize: 16, color: Color(0xbb333333)),
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
                    errorStyle: const TextStyle(color: Colors.red), // 设置验证错误消息为蓝色
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
                 }},
                cursorColor: Colors.blue, // 设置光标颜色为红色
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController, // 使用控制器
                decoration: InputDecoration(
                  labelText: '密码',
                  labelStyle: const TextStyle(fontSize: 16, color: Color(0xbb333333)),
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
                  suffixIcon: _passwordController.text.isNotEmpty
                      ?GestureDetector(
                      onTap: (){
                    // 清空输入框
                    FocusScope.of(context).unfocus();
                    // 这里可以使用控制器来清空文本框内容
                    _passwordController.clear();
                  },
                      //child:Icon(Icons.clear, color: Colors.grey[400])
                      //child:SvgPicture.asset('assets/svg/clear.svg',color: Colors.grey[400], width: 8, height: 8,)
                      child:Image.asset('assets/images/clear.png', width: 8, height: 8)
                  ) : null,
                  errorStyle: const TextStyle(color: Colors.red), // 设置验证错误消息为蓝色
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
                cursorColor: Colors.blue, // 设置光标颜色为红色
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
                      Navigator.pushReplacementNamed(context,'/home'); // 跳转到首页,销毁
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage(title: "---")),); // 跳转，返回回到当前
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
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}