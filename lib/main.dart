import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/bloc/news_bloc.dart';
import 'package:flutter_news_app/homeScreen.dart';
import 'package:flutter_news_app/view/splash_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(create: (BuildContext context) => NewsBloc(),),
      ],
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}




const spinkit = SpinKitChasingDots(
  color: Colors.blue,
  size: 40.0,
);



