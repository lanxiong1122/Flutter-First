import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget{
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();

}

class HomeTabState extends State<HomeTab>{
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