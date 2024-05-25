import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Login/login_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Login/login_event.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Login/login_state.dart';
import 'package:wardrobe_mobile/model/user.dart';
import 'package:wardrobe_mobile/pages/RoutePage.dart';
import 'package:wardrobe_mobile/pages/auth/registerView.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController =  TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late LoginBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    bloc = BlocProvider.of<LoginBloc>(context);
    
  }

  void resetField(){
    usernameController.text = "";
    passwordController.text = "";
  }

  final load = BlocBuilder<LoginBloc, LoginState>(builder: (context, state){
    if (state is LoginLoading){
      return CircularProgressIndicator();
    }
    return Container();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#ece6f7"),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state){
          if (state is LoginSuccessState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RoutePage()), (route) => false);
            bloc.add(LoginButtonReset());
          }
          else if (state is UsernameErrorState){
            SnackBar snackbar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            resetField();
          } else if (state is PasswordErrorState){
            SnackBar snackbar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            resetField();
          }
          else if (state is LoginErrorState){
            SnackBar snackbar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            resetField();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _loginText(),
                  const SizedBox(height: 7.0),
                  _usernameField(),
                  const SizedBox(height: 7.0),
                  _passwordField(),
                  const SizedBox(height: 7.0),
                  load,
                  _submitButton(),
                  _signupLink(),
                ]
              ),
            ),
          ),
        ),
      )
      );
  }

  Widget _loginText(){
    return Text('Login', 
      style:
        TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: HexColor("#272360")
    ));
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

  Widget _passwordField(){
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Please enter password";
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
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: SizedBox(
        width: 400.0,
        height: 50.0,
        child: ElevatedButton(
          onPressed:() async {
            if (_formKey.currentState!.validate()){
              // add bloc event
              UserModel user = UserModel(
                username: usernameController.text.trim(),
                password: passwordController.text.trim(),
              );
              bloc.add(LoginButtonPressed(user: user));
              // rmb shared preference
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder( borderRadius: BorderRadius.circular(24.0),)
              ),
              backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#272360")),

            ),
          child: Text('LOGIN', style: TextStyle(fontSize: 16, color: HexColor("#FFE6E6")),)),
      ),
    );
  }

  Widget _signupLink(){
    return Container(
        child: TextButton(
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterView(),));
          },
          child: Text('Don\'t have an account? Sign up here', style: TextStyle(fontSize: 12)),
        )
    ); 
  }
}