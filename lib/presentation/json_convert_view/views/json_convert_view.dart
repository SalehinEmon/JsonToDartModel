import 'dart:convert';

import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_to_dart_model/presentation/custom_widget/app_text_field.dart';
import 'package:json_to_dart_model/presentation/json_convert_view/bloc/json_convert_bloc.dart';

class JsonConvertView extends StatefulWidget {
  const JsonConvertView({super.key});

  @override
  State<JsonConvertView> createState() => _JsonConvertViewState();
}

class _JsonConvertViewState extends State<JsonConvertView> {
  TextEditingController jsonInputController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  String? outputDatas = '';
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => JsonConvertBloc(),
        ),
      ],
      child: BlocConsumer<JsonConvertBloc, JsonConvertState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        AppTextFiled(
                          controller: jsonInputController,
                          hintText: "Json data",
                          labeltext: "Json data",
                        ),
                        AppTextFiled(
                          controller: classNameController,
                          hintText: "Class Name",
                          labeltext: "Class Name",
                        ),
                        ElevatedButton(
                          style: largeButtonStyle,
                          onPressed: () {
                            context.read<JsonConvertBloc>().add(
                                  ConvertToModelEvent(
                                    jsonInputController.text,
                                    classNameController.text,
                                  ),
                                );
                          },
                          child: const Text("Generate"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: largeButtonStyle,
                          onPressed: () async {
                            String? tempConvertedStr = '';
                            if (state is ConvertSuccessState) {
                              tempConvertedStr = state.dartModelStr;
                            }

                            if (tempConvertedStr.isNotEmpty) {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: tempConvertedStr,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Copy to Clipboard!!"),
                              ));
                            }
                          },
                          child: const Text("Copy To Clipboard"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: largeButtonStyle,
                          onPressed: () {
                            context
                                .read<JsonConvertBloc>()
                                .add(JsonParseEvent(jsonInputController.text));
                          },
                          child: const Text("Parse"),
                        ),
                        ElevatedButton(
                          style: largeButtonStyle,
                          onPressed: () {
                            context
                                .read<JsonConvertBloc>()
                                .add(ConvertToCsModelEvent(
                                  jsonInputController.text,
                                  classNameController.text,
                                ));
                          },
                          child: const Text("To Cs Model"),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        state is ConvertSuccessState
                            ? SelectableText(state.dartModelStr)
                            : state is ConvertFailedState
                                ? Text(state.failedMeg)
                                : const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

ButtonStyle largeButtonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size(327, 50),
  //backgroundColor: AppColor.primaryColor,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(50),
    ),
  ),
);
