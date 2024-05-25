import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/pages/RoutePage.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController usernameController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register an account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                _usernameField(),
                const SizedBox(height: 7.0),
                _emailField(),
                const SizedBox(height: 7.0),
                _firstnameField(),
                const SizedBox(height: 7.0),
                _lastnameField(),
                const SizedBox(height: 7.0),
                _passwordField(),
                const SizedBox(height: 7.0),
                _confirmPasswordField(),
                const SizedBox(height: 7.0),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _usernameField(){
    return TextFormField(
      controller: usernameController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter username";
        }
        if (value.trim().contains(' ')){
          List<String> words = value.split(' ');
          if (words.length > 1){
            return "Username cannot contain whitespace";
          }
        }
      },
      decoration: InputDecoration(
        hintText: 'Username',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _emailField(){
    return TextFormField(
      controller: emailController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter username";
        }
        if (!value.trim().contains('@')){
            return 'Email is not completed';
          }
          return null;
      },
      decoration: InputDecoration(
        hintText: 'Email',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _firstnameField(){
    return TextFormField(
      controller: firstnameController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter first name";
        }
      },
      decoration: InputDecoration(
        hintText: 'First name',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  } 

  Widget _lastnameField(){
    return TextFormField(
      controller: lastnameController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter first name";
        }
      },
      decoration: InputDecoration(
        hintText: 'Last name',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _passwordField(){
    return TextFormField(
      controller: password1Controller,
      obscureText: true,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter password";
        }
        if (value.length < 8){
          return "Password needs to be minumum 8 characters";
        }
      },
      decoration: InputDecoration(
        hintText: 'Password',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _confirmPasswordField(){
    return TextFormField(
      controller: password2Controller,
      obscureText: true,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter password";
        }
        if (value != password1Controller.text){
          return "Password does not match";
        }
      },
      decoration: InputDecoration(
        hintText: 'Password',
        focusColor: HexColor("#272360"),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _submitButton(){
    return Center(
      child: SizedBox(
        width: 400.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()){
              // add bloc event.
              var pref = await SharedPreferences.getInstance();
              pref.setBool('isLogged', true);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RoutePage(),), (route) => false);
            }
          },
          child: Text('Register')
        ),

      ),
    );
  }
}
