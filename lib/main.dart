import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/creategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/creategarment_state.dart';
import 'package:wardrobe_mobile/pages/garment/detectGarmentView.dart';
import 'package:wardrobe_mobile/pages/homeView.dart';
import 'package:wardrobe_mobile/repository/garment_repo.dart';

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
      ],
      child: MaterialApp(
        title: 'Yourdrobe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
    return HomePage();
  }
}