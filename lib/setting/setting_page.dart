import 'package:flutter/material.dart';

/// author lanxiong 
/// date 
/// describe：
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 禁用自动返回按钮
        title: Text('设置'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          CustomSettingItem(
            icon: Icons.account_circle,
            title: '账户设置',
            onTap: () {
              Navigator.pushNamed(context, '/accountSettings');
            },
          ),
          Divider(),
          CustomSettingItem(
            icon: Icons.notifications,
            title: '通知设置',
            onTap: () {
              Navigator.pushNamed(context, '/notificationSettings');
            },
          ),
          Divider(),
          CustomSettingItem(
            icon: Icons.lock,
            title: '隐私设置',
            onTap: () {
              Navigator.pushNamed(context, '/privacySettings');
            },
          ),
          Divider(),
          CustomSettingItem(
            icon: Icons.palette,
            title: '主题设置',
            onTap: () {
              Navigator.pushNamed(context, '/themeSettings');
            },
          ),
          Divider(),
          CustomSettingItem(
            icon: Icons.language,
            title: '语言设置',
            onTap: () {
              Navigator.pushNamed(context, '/languageSettings');
            },
          ),
          Divider(),
          CustomSettingItem(
            icon: Icons.help_outline,
            title: '帮助与反馈',
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
      Divider(),
      CustomSettingItem(
        icon: Icons.local_activity,
        title: '本地Webview（js交互）',
        onTap: () {
          Navigator.pushNamed(context, '/webview', arguments: {'htmlAssetPath': 'assets/go.html'});
        },
      ),
          Divider(),
          CustomSettingItem(
            icon: Icons.local_activity,
            title: '链接Webview',
            onTap: () {
              Navigator.pushNamed(context, '/webview', arguments: {'url': 'https://www.jd.com'});
            },
          ),
          // 可以继续添加更多设置项
        ],
      ),
    );
  }
}

class CustomSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  CustomSettingItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(icon, size: 24, color: Colors.blue),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}