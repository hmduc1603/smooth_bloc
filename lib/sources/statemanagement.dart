import 'package:flutter/material.dart';

class StateManagement {
  static final StateManagement _singleton = StateManagement._internal();

  StateManagement._internal();

  factory StateManagement() {
    return _singleton;
  }

  late Widget Function(String message) appDialogBuilder;
  late Widget Function(
    String? title,
    String? message,
    String? buttonTitle,
    String? altButtonTitle,
    Widget? decorationWidget,
    VoidCallback onPressedAltBtn,
    VoidCallback onPressedBtn,
  ) appOptionalDialogBuilder;
  late Widget Function(String message) appLoadingBuilder;

  /// It's compulsory to call this setUp function before run app
  void setUp({
    required Widget Function(String message) appDialogBuilder,
    required Widget Function(String message) appLoadingHUDBuilder,
    required Widget Function(
      String? title,
      String? message,
      String? buttonTitle,
      String? altButtonTitle,
      Widget? decorationWidget,
      VoidCallback onPressedAltBtn,
      VoidCallback onPressedBtn,
    ) appOptionalDialogBuilder,
    required Widget Function(String message) appLoadingBuilder,
  }) {
    _singleton.appDialogBuilder = appDialogBuilder;
    _singleton.appOptionalDialogBuilder = appOptionalDialogBuilder;
    _singleton.appLoadingBuilder = appLoadingHUDBuilder;
  }
}
