import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/features/bloc/category_cover_bloc/category_bloc.dart';
import 'package:wallpaper_app/features/bloc/home_screen_bloc/wallpaper_bloc.dart';
import 'package:wallpaper_app/data_source/remote/api_helper.dart';
import 'package:wallpaper_app/features/bloc/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/features/screens/home_screen.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => WallpaperBloc(apiHelper: ApiHelper())),
      BlocProvider(create: (context) => CategoryBloc(apiHelper: ApiHelper())),
      BlocProvider(create: (context) => SearchBloc(apiHelper: ApiHelper())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper App',
      debugShowCheckedModeBanner: false,
      home: MyHomeScreen(),
    );
  }
}
