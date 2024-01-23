// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smooth_bloc/sources/base_state.dart';
import 'base_event.dart';

abstract class BaseCubit<S extends BaseState> extends Cubit<S> {
  //Core
  final eventSubject = PublishSubject<BaseEvent>();
  Stream<BaseEvent> get eventStream => eventSubject.stream;

  BaseCubit(S initialState) : super(initialState);

  showLoading({bool hasBlurBackground = true, dynamic message}) {
    _addToEvent(LoadingEvent(
        isLoading: true,
        hasBlurBackground: hasBlurBackground,
        message: message));
  }

  hideLoading({bool hasBlurBackground = true}) {
    _addToEvent(
        LoadingEvent(isLoading: false, hasBlurBackground: hasBlurBackground));
  }

  showMessage(dynamic msg) {
    _addToEvent(MessageEvent(msg: msg));
  }

  handleError(dynamic error) {
    _addToEvent(ErrorEvent(error: error));
  }

  _addToEvent(BaseEvent event) {
    if (!eventSubject.isClosed) {
      eventSubject.add(event);
    }
  }

  @override
  Future<void> close() {
    eventSubject.close();
    return super.close();
  }

  @override
  void emit(S state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
