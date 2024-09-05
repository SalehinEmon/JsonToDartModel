import 'package:flutter/material.dart';
import 'package:json_to_dart_model/config/app_theme.dart';
import 'package:json_to_dart_model/presentation/json_convert_view/views/json_convert_view.dart';

class AppStart extends StatefulWidget {
  const AppStart({super.key});

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Json to model",
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      // onGenerateRoute: RouteGenerator.generateRoute,

      home: const JsonConvertView(),
      //home: const PleaseWaitView(),
    );
  }
}
