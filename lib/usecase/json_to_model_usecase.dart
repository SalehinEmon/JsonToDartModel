import 'dart:convert';

import 'package:change_case/change_case.dart';
import 'package:dart_style/dart_style.dart';
import 'package:dartz/dartz.dart';
import 'package:json_to_dart_model/data/model/failures.dart';

class JsonToModelUsecase {
  Either<Failure, String> getModelFromJson(
      String inputJson, String? className) {
    var formatter = DartFormatter();
    String dartModelStr = '';

    try {
      String temp = inputJson;
      Map<dynamic, dynamic> jsonMap = {};
      while (true) {
        if (temp[0] != '"' && temp[temp.length - 1] != '"' && temp[1] == '\\') {
          temp = '"$temp"';
        }
        var tempStr = jsonDecode(temp);

        if (tempStr is String) {
          temp = tempStr;
        } else {
          jsonMap = tempStr;
          break;
        }
      }

      className = className ?? 'AutoClass';

      inputJson = 'class $className {';

      //first declaration of the variables
      jsonMap.forEach((k, v) {
        String key = '$k';
        key = key.toCamelCase();

        //print(key.toCamelCase());

        if (v is String) {
          inputJson += 'String? $key; \n';
        } else if (v is bool) {
          inputJson += 'bool? $key; \n';
        } else if (v is int) {
          inputJson += 'int? $key; \n';
        } else if (v is double) {
          inputJson += 'double? $key; \n';
        } else {
          inputJson += 'dynamic? $key; \n';
        }
      });

//constructor
      inputJson += '$className ({';

      jsonMap.forEach((k, v) {
        String key = '$k';
        key = key.toCamelCase();

        inputJson += 'this.$key,\n';
      });

      inputJson += '});';

      //from json function

      inputJson += '$className.fromJson(Map<String, dynamic> json) \n{';

      jsonMap.forEach((k, v) {
        String key = '$k';
        key = key.toCamelCase();

        inputJson += '$key= json[\'$k\']';
        if (v is String) {
          inputJson += '??\'\'';
        } else if (v is double || v is int) {
          inputJson += '??0';
        } else if (v is bool) {
          inputJson += '??false';
        }
        inputJson += ';\n';
      });

      inputJson += '}';

      //to json function
      inputJson += 'Map<String, dynamic> toJson()\n{';
      inputJson +=
          'final Map<String, dynamic> data = new Map<String, dynamic>();';

      jsonMap.forEach((k, v) {
        String key = '$k';
        key = key.toCamelCase();
        inputJson += 'data[\'$k\']=this.$key';

        if (v is String) {
          inputJson += '??\'\'';
        } else if (v is double || v is int) {
          inputJson += '??0';
        } else if (v is bool) {
          inputJson += '??false';
        }
        inputJson += ';\n';
      });

      inputJson += 'return data;';
      inputJson += '}';

      inputJson += ' }';

      inputJson = formatter.format(inputJson);
    } catch (e) {
      String errMsg = e is FormatException ? e.message : "Json Format error";
      if (e is FormatterException) {
        errMsg = "${e.errors[0].message} : ${e.errors[0].correction ?? ''}";
      }
      return left(JsonConvertFailure(errMsg, 400));
    }

    return Right(inputJson);
  }

  Either<Failure, String> parseJson(String inputJson) {
    try {
      var formatter = DartFormatter();
      String temp = inputJson;
      Map<dynamic, dynamic> jsonMap = {};
      while (true) {
        if (temp[0] != '"' && temp[temp.length - 1] != '"' && temp[1] == '\\') {
          temp = '"$temp"';
        }
        var tempStr = jsonDecode(temp);

        if (tempStr is String) {
          temp = tempStr;
        } else {
          jsonMap = tempStr;
          break;
        }
      }

      inputJson = '{\n';

      jsonMap.forEach((k, v) {
        if (v is String) {
          inputJson += '"$k":"$v"';
        } else if (v is double || v is int) {
          inputJson += '"$k":$v';
        } else if (v is bool) {
          inputJson += '"$k":$v';
        } else {
          inputJson += '"$k":$v';
        }
        inputJson += ',\n';
      });
      // print(inputJson[inputJson.length - 2]);

      if (inputJson[inputJson.length - 2] == ',') {
        inputJson = inputJson.substring(0, inputJson.length - 2);
      }
      inputJson += '\n}';
      //inputJson = formatter.format(inputJson);
    } catch (e) {
      String errMsg = e is FormatException ? e.message : "Json Format error";
      if (e is FormatterException) {
        errMsg = "${e.errors[0].message} : ${e.errors[0].correction ?? ''}";
      }
      return left(JsonConvertFailure(errMsg, 400));
    }
    return Right(inputJson);
  }
}

// Map<dynamic, dynamic> convertToMap(String inputStr) {
//    Map<dynamic, dynamic> jsonMap = {};
//   String temp = inputStr;
//   while (true) {
//     if (temp[0] != '"' && temp[temp.length - 1] != '"' && temp[1] == '\\') {
//       temp = '"$temp"';
//     }
//     var tempStr = jsonDecode(temp);

//     if (tempStr is String) {
//       temp = tempStr;
//     } else {
//       jsonMap = tempStr;
//       break;
//     }
//   }
// }
