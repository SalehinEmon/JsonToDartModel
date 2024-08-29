part of 'json_convert_bloc.dart';

abstract class JsonConvertEvent {}

class ConvertToModelEvent extends JsonConvertEvent {
  String inputJson;
  String className;
  ConvertToModelEvent(
    this.inputJson,
    this.className,
  );
}

class ConvertToCsModelEvent extends JsonConvertEvent {
  String inputJson;
  String className;
  ConvertToCsModelEvent(
    this.inputJson,
    this.className,
  );
}

class JsonParseEvent extends JsonConvertEvent {
  String inputJson;

  JsonParseEvent(this.inputJson);
}
