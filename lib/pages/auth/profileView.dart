import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/pages/auth/splashScreen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _displayUser(),
              _logoutButton()
            ]
          ),
        ),
      )

    );
  }

  Widget _displayUser(){
    return Text("Hello Tong Yung Huey");
  }

  Widget _logoutButton(){
    return ElevatedButton(
      onPressed: () async {
        // bloc to update status in db
        var pref = await SharedPreferences.getInstance();
        pref.remove('isLogged');

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SplashScreen()), (route) => false);
      }, 
      child: Text('Logout')
    );
  }
}