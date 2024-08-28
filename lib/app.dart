import 'package:flutter/material.dart';
import 'package:json_to_dart_model/presentation/json_convert_view/views/json_convert_view.dart';

class AppStart extends StatefulWidget {
  const AppStart({super.key});

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      // onGenerateRoute: RouteGenerator.generateRoute,

      home: JsonConvertView(),
      //home: const PleaseWaitView(),
    );
  }
}
