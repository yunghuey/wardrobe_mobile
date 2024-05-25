import 'package:flutter/material.dart';
import 'package:wardrobe_mobile/pages/auth/profileView.dart';
import 'package:wardrobe_mobile/pages/garment/homeView.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _currentIndex = 0;

  final List<Widget> _tablist = [
    HomePage(),
    ProfileView(),
    // Text("home", style: TextStyle(fontSize: 40),),
    // Text("profile", style: TextStyle(fontSize: 40),),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _tablist,
      ),
      // body: Center(child: _tablist[_currentIndex],),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index){
          setState((){
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.brown,
          ),
        ],
      ),
    );
  }
}