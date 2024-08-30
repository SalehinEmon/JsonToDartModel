part of 'json_convert_bloc.dart';

abstract class JsonConvertEvent {}

class ConvertToModelEvent extends JsonConvertEvent {
  String inputJson;
  String className;
  bool? isNullAble;
  bool? isNullSafe;
  ConvertToModelEvent(
    this.inputJson,
    this.className,
    this.isNullAble,
    this.isNullSafe,
  );
}

class ConvertToCsModelEvent extends JsonConvertEvent {
  String inputJson;
  String className;
  bool? isNullAble;
  bool? isNullSafe;
  ConvertToCsModelEvent(
    this.inputJson,
    this.className,
    this.isNullAble,
    this.isNullSafe,
  );
}

class JsonParseEvent extends JsonConvertEvent {
  String inputJson;

  JsonParseEvent(this.inputJson);
}
