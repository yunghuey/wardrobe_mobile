import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/pages/RoutePage.dart';
import 'package:wardrobe_mobile/pages/auth/loginView.dart';
import 'package:wardrobe_mobile/pages/garment/homeView.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  Future<String?> checkLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 1000),() async {
      String? logged = await checkLogged();
      if (logged != null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RoutePage() ), (route) => false);
      }
      else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginView() ), (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#272360"),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: _content()
        ),
      );
  }

  Widget _content(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Yourdrobe', style: TextStyle(
            fontSize: 50.0,
            color: HexColor("#E5D7FD")
          )),
          Text('Your long life partner', style: TextStyle(
            fontSize: 25.0,
            color: HexColor("#E5D7FD")
          )),
        ]
      ),
    );
  }
}