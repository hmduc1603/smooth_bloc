import 'package:flutter/material.dart';

class SmoothBloc {
  static final SmoothBloc _singleton = SmoothBloc._internal();

  SmoothBloc._internal();

  factory SmoothBloc() {
    return _singleton;
  }

  late Widget Function(String message) appDialogBuilder;

  late Widget Function(String message) appLoadingBuilder;

  /// It's compulsory to call this setUp function before run app
  void setUp({
    required Widget Function(String message)? appDialogBuilder,
    required Widget Function(String message)? appLoadingBuilder,
  }) {
    _singleton.appDialogBuilder =
        appDialogBuilder ?? _getDefaultSmoothBlocDialogBuilder;
    _singleton.appLoadingBuilder =
        appLoadingBuilder ?? _getDefaultSmoothBlocLoadingBuilder;
  }
}

Widget _getDefaultSmoothBlocDialogBuilder(String message) {
  return _DefaultSmoothBlocDialogBuilder(message: message);
}

Widget _getDefaultSmoothBlocLoadingBuilder(String message) {
  return const _DefaultSmoothBlocLoadingBuilder();
}

class _DefaultSmoothBlocDialogBuilder extends StatelessWidget {
  const _DefaultSmoothBlocDialogBuilder({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Text(message),
    );
  }
}

class _DefaultSmoothBlocLoadingBuilder extends StatelessWidget {
  const _DefaultSmoothBlocLoadingBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: const Center(
        child: SizedBox.square(
          dimension: 60,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
