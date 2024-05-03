import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/pages/garment/detectGarmentView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('homepage')),
      body: Column(
        children: [
          Text('this is home page'),
          Text('leave blank for future development'),
        ],
      ),
      floatingActionButton: _floatingButton(),
      drawer: _drawerMenu(),
    );
  }

  Widget _floatingButton(){
    return FloatingActionButton(
      onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> CaptureImageView())),
      child: Icon(Icons.add),
    );
  }

  Widget _drawerMenu(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text('drawer header')),
          ListTile(
            title: const Text('Home Page'),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
                fullscreenDialog: false,
              ),
              (route) => false,
            ),
          ),
          ListTile(
            title: const Text('item 2'),
            onTap: (){},
          ),
          ListTile(
            title: const Text('item 3'),
            onTap: (){},
          ),
        ],
      )
    );
  }

}