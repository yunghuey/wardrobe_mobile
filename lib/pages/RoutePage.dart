import 'package:flutter/material.dart';
import 'package:wardrobe_mobile/pages/auth/profileView.dart';
import 'package:wardrobe_mobile/pages/garment/garmentListView.dart';
import 'package:wardrobe_mobile/pages/garment/homeView.dart';

class RoutePage extends StatefulWidget {
  final int? page;
  const RoutePage({Key? key, this.page}) : super(key: key);
  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _currentIndex = 0;

  final List<Widget> _tablist = [
    HomeView(),
    GarmentListView(),
    ProfileView(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = widget.page ?? 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tablist,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_rounded),
            label: 'Garments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}