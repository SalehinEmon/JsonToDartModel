part of 'json_convert_bloc.dart';

abstract class JsonConvertState {}

class InitialState extends JsonConvertState {}

class LoadingState extends JsonConvertState {}

class ConvertSuccessState extends JsonConvertState {
  String dartModelStr;
  ConvertSuccessState(this.dartModelStr);
}

class ConvertFailedState extends JsonConvertState {
  String failedMeg;
  ConvertFailedState(this.failedMeg);
}
