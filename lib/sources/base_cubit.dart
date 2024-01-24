// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_bloc/sources/base_state.dart';
import 'base_event.dart';

abstract class BaseCubit<S extends BaseState> extends Cubit<S> {
  /// A stream subject manages BaseEvent

  final eventStreamController = StreamController<BaseEvent>.broadcast();
  Stream<BaseEvent> get eventStream => eventStreamController.stream;

  BaseCubit(S initialState) : super(initialState);

  /// Fire LoadingEvent which BaseView will listen and show Loading Screen
  showLoading({bool hasBlurBackground = true, dynamic message}) {
    _addToEvent(LoadingEvent(
        isLoading: true,
        hasBlurBackground: hasBlurBackground,
        message: message));
  }

  /// Fire LoadingEvent which BaseView will listen and hide Loading Screen
  hideLoading({bool hasBlurBackground = true}) {
    _addToEvent(
        LoadingEvent(isLoading: false, hasBlurBackground: hasBlurBackground));
  }

  /// Fire MessageEvent which BaseView will listen and show Dialog
  showMessage(dynamic msg) {
    _addToEvent(MessageEvent(msg: msg));
  }

  /// Fire MessageEvent which BaseView will listen and show an Error Dialog
  handleError(dynamic error) {
    _addToEvent(ErrorEvent(error: error));
  }

  _addToEvent(BaseEvent event) {
    if (!eventStreamController.isClosed) {
      eventStreamController.add(event);
    }
  }

  /// Close Cubit
  @override
  Future<void> close() {
    eventStreamController.close();
    return super.close();
  }

  /// Emit new state that should trigger screen rebuilding
  @override
  void emit(S state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
