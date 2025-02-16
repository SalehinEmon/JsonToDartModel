import 'dart:convert';
import 'package:change_case/change_case.dart';
import 'package:dart_style/dart_style.dart';

class JsonHelper {
  static String toDartModel(String inputJson, String? className,
      {bool isNullable = false, bool isNullsafe = false}) {
    className = checkClassName(className);
    Map<dynamic, dynamic> jsonMap = JsonHelper.stringToMap(inputJson);
    var formatter = DartFormatter();

    inputJson = JsonHelper.initializeVariable(jsonMap, className,
        isNullable: isNullable);

    //constructor
    inputJson += JsonHelper.initializeConstructor(
      jsonMap,
      className,
      isNullable: isNullable,
    );
    //from json function
    inputJson += JsonHelper.fromJsonFunction(
      jsonMap,
      className,
      nullSafe: isNullsafe,
    );
    //to json function
    inputJson += JsonHelper.toJsonFunction(
      jsonMap,
      className,
      nullSafe: isNullsafe,
    );

    inputJson = formatter.format(inputJson);

    return inputJson;
  }

  static Map<dynamic, dynamic> stringToMap(String inputJson) {
    Map<dynamic, dynamic> jsonMap = {};
    String temp = inputJson;
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

    return jsonMap;
  }

  static String initializeVariable(
      Map<dynamic, dynamic> jsonMap, String? className,
      {bool isNullable = true}) {
    className = checkClassName(className);
    String inputJson = '\n\n';
    //className = className ?? 'AutoClass';

    inputJson = 'class $className {\n\n';

    jsonMap.forEach((k, v) {
      String key = '$k';
      key = key.toCamelCase();

      //print(key.toCamelCase());

      if (v is String) {
        inputJson += 'String${isNullable ? '?' : ''} $key; \n';
      } else if (v is bool) {
        inputJson += 'bool${isNullable ? '?' : ''} $key; \n';
      } else if (v is int) {
        inputJson += 'int${isNullable ? '?' : ''} $key; \n';
      } else if (v is double) {
        inputJson += 'double${isNullable ? '?' : ''} $key; \n';
      } else {
        inputJson += 'dynamic${isNullable ? '?' : ''} $key; \n';
      }
    });

    return inputJson;
  }

  static String initializeConstructor(
    Map<dynamic, dynamic> jsonMap,
    String? className, {
    bool isNullable = false,
  }) {
    className = checkClassName(className);
    String inputJson = '\n\n';
    inputJson += '$className ({';

    jsonMap.forEach((k, v) {
      String key = '$k';
      key = key.toCamelCase();
      if (!isNullable) {
        inputJson += 'required ';
      }

      inputJson += 'this.$key,\n';
    });

    inputJson += '});\n\n';

    return inputJson;
  }

  static String fromJsonFunction(
      Map<dynamic, dynamic> jsonMap, String? className,
      {bool nullSafe = true}) {
    String inputJson = '\n\n';
    className = checkClassName(className);
    inputJson += '$className.fromJson(Map<String, dynamic> json) \n{';

    jsonMap.forEach((k, v) {
      String key = '$k';
      key = key.toCamelCase();
      if (v is double) {
        inputJson +=
            '$key= ($key is int) ? ($key as int).toDouble() : json[\'$k\']';
      } else {
        inputJson += '$key= json[\'$k\']';
      }
      if (v is String && nullSafe) {
        inputJson += '??\'\'';
      } else if ((v is int) && nullSafe) {
        inputJson += '??0';
      } else if (v is bool && nullSafe) {
        inputJson += '??false';
      }
      inputJson += ';\n';
    });

    inputJson += '}\n\n';

    return inputJson;
  }

  static String toJsonFunction(Map<dynamic, dynamic> jsonMap, String? className,
      {bool nullSafe = true}) {
    className = checkClassName(className);
    String inputJson = '\n\n';
    inputJson += 'Map<String, dynamic> toJson()\n{';
    inputJson +=
        'final Map<String, dynamic> data = new Map<String, dynamic>();';

    jsonMap.forEach((k, v) {
      String key = '$k';
      key = key.toCamelCase();
      inputJson += 'data[\'$k\']=this.$key';

      if (v is String && nullSafe) {
        inputJson += '??\'\'';
      } else if ((v is double || v is int) && nullSafe) {
        inputJson += '??0';
      } else if (v is bool && nullSafe) {
        inputJson += '??false';
      }
      inputJson += ';\n';
    });

    inputJson += 'return data;';
    inputJson += '}';

    inputJson += ' }';

    return inputJson;
  }

  static String toCsModelClass(
      Map<dynamic, dynamic> jsonMap, String? className) {
    className = checkClassName(className);
    String inputJson = 'public class $className\n{\n';

    jsonMap.forEach((k, v) {
      if (v is String) {
        inputJson += '      public string $k';
      } else if (v is double || v is int) {
        inputJson += '      public double $k';
      } else if (v is bool) {
        inputJson += '      public bool $k';
      } else {
        inputJson += '      public dynamic $k';
      }
      inputJson += ';\n\n';
    });

    inputJson += '}';

    return inputJson;
  }

  static String parseJson(String inputJson) {
    Map<dynamic, dynamic> jsonMap = stringToMap(inputJson);

    inputJson = '{\n';

    jsonMap.forEach((k, v) {
      if (v is String) {
        inputJson += '    "$k" : "$v"';
      } else if (v is double || v is int) {
        inputJson += '    "$k" : $v';
      } else if (v is bool) {
        inputJson += '    "$k" : $v';
      } else {
        inputJson += '    "$k" : $v';
      }
      inputJson += ',\n';
    });
    // print(inputJson[inputJson.length - 2]);

    if (inputJson[inputJson.length - 2] == ',') {
      inputJson = inputJson.substring(0, inputJson.length - 2);
    }
    inputJson += '\n}';
    return inputJson;
  }

  static String checkClassName(String? className) {
    return (className == null || className.isEmpty) ? 'AutoClass' : className;
  }
}

class AutoClass {
  double? firstName;
  String? lastName;

  AutoClass({
    this.firstName,
    this.lastName,
  });

  AutoClass.fromJson(Map<String, dynamic> json) {
    firstName =
        (firstName is int) ? (firstName as int).toDouble() : json['firstName'];
    lastName = json['lastName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName ?? 0;
    data['lastName'] = this.lastName ?? '';
    return data;
  }
}
