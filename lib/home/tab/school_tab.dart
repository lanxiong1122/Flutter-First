import 'package:flutter/material.dart';

/// author lanxiong
/// date 
/// describe：

class SchoolTab extends StatefulWidget {
  const SchoolTab({super.key});

  @override
  _SchoolTabState createState() => _SchoolTabState();
}

class _SchoolTabState extends State<SchoolTab> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("首页")
      ),
      body: Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: 300,
                height: 200,
                color: Colors.green ,
                child: Text("One")
            ),
            Container(
                width: 300,
                height: 200,
                color: Colors.green ,
                child: Text("Two")
            ),
            Container(
                width: 300,
                height: 200,
                color: Colors.green ,
                child: Text("Three")
            )
          ],
        ),
      ),
    );
  }
}