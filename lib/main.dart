import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_state.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_state.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_state.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_state.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/readgarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/readgarment_state.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_state.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Login/login_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Login/login_state.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Logout/logout_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Logout/logout_state.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Register/register_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/Authentication/Register/register_state.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_bloc.dart';
import 'package:wardrobe_mobile/bloc/user/GetUserDetails/getuser_state.dart';
import 'package:wardrobe_mobile/pages/auth/splashScreen.dart';
import 'package:wardrobe_mobile/repository/analysis_repo.dart';
import 'package:wardrobe_mobile/repository/garment_repo.dart';
import 'package:wardrobe_mobile/repository/user_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateGarmentBloc>(create: (context) => CreateGarmentBloc(CreateGarmentInitState(), GarmentRepository())),
        BlocProvider<ReadGarmentBloc>(create: (context) => ReadGarmentBloc(ReadGarmentInitState(), GarmentRepository())),
        BlocProvider<ReadOneGarmentBloc>(create: (context) => ReadOneGarmentBloc(ReadOneGarmentInitState(), GarmentRepository())),
        BlocProvider<DeleteGarmentBloc>(create: (context) => DeleteGarmentBloc(DeleteGarmentInitState(), GarmentRepository())),
        BlocProvider<UpdateGarmentBloc>(create: (context) => UpdateGarmentBloc(UpdateGarmentInitState(), GarmentRepository())),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(LoginInitState(), UserRepository())),
        BlocProvider<LogoutBloc>(create: (context) => LogoutBloc(LogoutInitState(), UserRepository())),
        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc(RegisterInitState(), UserRepository())),
        BlocProvider<UserProfileBloc>(create: (context) => UserProfileBloc(UserProfileInitState(), UserRepository())),
        BlocProvider<DisplayAnalysisBloc>(create: (context) => DisplayAnalysisBloc(DisplayAnalysisInitState(), AnalysisRepository())),

      ],
      child: MaterialApp(
        title: 'Yourdrobe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 88, 73, 115)),
          useMaterial3: true,
        ),
        home: IntroPage(),
        ),
    );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}