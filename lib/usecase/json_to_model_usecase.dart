import 'package:dart_style/dart_style.dart';
import 'package:dartz/dartz.dart';
import 'package:json_to_dart_model/data/model/failures.dart';
import 'package:json_to_dart_model/util/json_helper.dart';

class JsonToModelUsecase {
  Either<Failure, String> getDartModelFromJson(
    String inputJson,
    String? className, {
    bool isNullable = false,
    bool isNullsafe = false,
  }) {
    try {
      inputJson = JsonHelper.toDartModel(
        inputJson,
        className,
        isNullable: isNullable,
        isNullsafe: isNullsafe,
      );
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
      inputJson = JsonHelper.parseJson(inputJson);
    } catch (e) {
      String errMsg = e is FormatException ? e.message : "Json Format error";
      if (e is FormatterException) {
        errMsg = "${e.errors[0].message} : ${e.errors[0].correction ?? ''}";
      }
      return left(JsonConvertFailure(errMsg, 400));
    }
    return Right(inputJson);
  }

  Either<Failure, String> jsonToCsModel(String inputJson, String className) {
    try {
      Map<dynamic, dynamic> jsonMap = JsonHelper.stringToMap(inputJson);
      inputJson = JsonHelper.toCsModelClass(jsonMap, className);
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
