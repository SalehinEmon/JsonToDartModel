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
  bool isNullSafe = true;
  bool isNullable = true;
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
            appBar: AppBar(
              title: const Text("Convert Json string to model"),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          AppTextFiled(
                            maxLine: 10,
                            controller: jsonInputController,
                            hintText: "Json data",
                            labeltext: "Json data",
                            suffixIcon: IconButton(
                              onPressed: () {
                                jsonInputController.clear();
                              },
                              icon: const Icon(Icons.highlight_off),
                            ),
                          ),
                          AppTextFiled(
                            controller: classNameController,
                            hintText: "Class Name",
                            labeltext: "Class Name",
                            suffixIcon: IconButton(
                              onPressed: () {
                                classNameController.clear();
                              },
                              icon: const Icon(Icons.highlight_off),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  const Text("Nullable"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Switch(
                                    value: isNullable,
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          isNullable = value;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Null Safe"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Switch(
                                    value: isNullSafe,
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          isNullSafe = value;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: largeButtonStyle,
                                onPressed: () {
                                  context.read<JsonConvertBloc>().add(
                                        ConvertToModelEvent(
                                          jsonInputController.text,
                                          classNameController.text,
                                          isNullable,
                                          isNullSafe,
                                        ),
                                      );
                                },
                                child: const Text("Dart Model"),
                              ),
                              ElevatedButton(
                                style: largeButtonStyle,
                                onPressed: () {
                                  context
                                      .read<JsonConvertBloc>()
                                      .add(ConvertToCsModelEvent(
                                        jsonInputController.text,
                                        classNameController.text,
                                        isNullable,
                                        isNullSafe,
                                      ));
                                },
                                child: const Text("Cs Model"),
                              ),
                              ElevatedButton(
                                style: largeButtonStyle,
                                onPressed: () {
                                  context.read<JsonConvertBloc>().add(
                                      JsonParseEvent(jsonInputController.text));
                                },
                                child: const Text("Parse"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            icon: const Icon(Icons.content_copy_outlined),
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          state is ConvertFailedState
                              ? Text(
                                  state.failedMeg,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 5,
                        right: 5,
                        bottom: 20,
                      ),
                      shrinkWrap: true,
                      children: [
                        state is ConvertSuccessState
                            ? SelectableText(
                                state.dartModelStr,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              )
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
  //minimumSize: const Size(327, 50),
  //backgroundColor: AppColor.primaryColor,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(50),
    ),
  ),
);
