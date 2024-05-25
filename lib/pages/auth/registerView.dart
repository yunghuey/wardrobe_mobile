import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Register/register_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Register/register_event.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Register/register_state.dart';
import 'package:wardrobe_mobile/model/user.dart';
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

  late RegisterBloc registerbloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerbloc = BlocProvider.of<RegisterBloc>(context);
  }

  final load = BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state){
    if (state is RegisterLoading){
      return CircularProgressIndicator();
    }
    return Container();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#ece6f7"),
      appBar: AppBar(title: Text('Register an account')),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state){
          if (state is RegisterSuccess){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RoutePage(),), (route) => false);
          }
          else if (state is EmailFailState){
            final snackbar = SnackBar(content: Text('Email is already exist'));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
          else if (state is UsernameFailState){
            final snackbar = SnackBar(content: Text('Username is already exist'));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
          else if(state is RegisterFailState){
            final snackbar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
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
                  load,
                  _submitButton(),
                ],
              ),
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
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter email";
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
          return "Please enter last name";
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
        hintText: 'Confirm password',
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
              UserModel user = UserModel(
                username: usernameController.text.trim(),
                email: emailController.text.trim(),
                firstname: firstnameController.text.trim(),
                lastname: lastnameController.text.trim(),
                password: password1Controller.text.trim()
              );
              registerbloc.add(RegisterButtonPressed(user: user));
            }
          },
          child: Text('Register')
        ),

      ),
    );
  }
}
