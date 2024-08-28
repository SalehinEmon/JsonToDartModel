abstract class Failure {
  final String messsage;
  int statusCode;
  Failure(this.messsage, this.statusCode);
}

class JsonConvertFailure extends Failure {
  JsonConvertFailure(super.messsage, super.statusCode);
}

class DataLoadFailure extends Failure {
  DataLoadFailure(super.messsage, super.statusCode);
}
