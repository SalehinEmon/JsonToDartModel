import 'package:bloc/bloc.dart';
import 'package:json_to_dart_model/usecase/json_to_model_usecase.dart';
import 'package:meta/meta.dart';

part 'json_convert_event.dart';
part 'json_convert_state.dart';

class JsonConvertBloc extends Bloc<JsonConvertEvent, JsonConvertState> {
  final JsonToModelUsecase _jsonToModelUsecase = JsonToModelUsecase();
  String convertedStr = '';

  JsonConvertBloc() : super(InitialState()) {
    on<ConvertToModelEvent>(onConvertToModel);
    on<JsonParseEvent>(onJsonParseEvent);
    on<ConvertToCsModelEvent>(onConvertToCsModelEvent);
  }

  onConvertToCsModelEvent(event, emit) {
    emit(LoadingState());
    var jsonConvertResult =
        _jsonToModelUsecase.jsonToCsModel(event.inputJson, event.className);

    if (jsonConvertResult.isLeft()) {
      jsonConvertResult.fold((failure) {
        emit(ConvertFailedState(failure.messsage));
      }, (_) {});
    }

    jsonConvertResult.fold((_) {}, (converteStrVal) {
      convertedStr = converteStrVal;
      emit(ConvertSuccessState(converteStrVal));
    });
  }

  onJsonParseEvent(event, emit) {
    emit(LoadingState());
    var jsonConvertResult = _jsonToModelUsecase.parseJson(event.inputJson);

    if (jsonConvertResult.isLeft()) {
      jsonConvertResult.fold((failure) {
        emit(ConvertFailedState(failure.messsage));
      }, (_) {});
    }

    jsonConvertResult.fold((_) {}, (converteStrVal) {
      convertedStr = converteStrVal;
      emit(ConvertSuccessState(converteStrVal));
    });
  }

  onConvertToModel(event, emit) {
    emit(LoadingState());
    String className = '';

    if ((event.className as String).isEmpty || event.className == null) {
      className = 'AutoClass';
    } else {
      className = event.className;
    }
    var jsonConvertResult = _jsonToModelUsecase.getDartModelFromJson(
      event.inputJson,
      className,
      isNullable: event.isNullAble,
      isNullsafe: event.isNullSafe,
    );
    if (jsonConvertResult.isLeft()) {
      jsonConvertResult.fold((failure) {
        emit(ConvertFailedState(failure.messsage));
      }, (_) {});
    }
    jsonConvertResult.fold((_) {}, (converteStrVal) {
      convertedStr = converteStrVal;
      emit(ConvertSuccessState(converteStrVal));
    });
  }
}
