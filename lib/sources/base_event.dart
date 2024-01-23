import 'package:flutter/material.dart';

abstract class BaseEvent {}

class MessageEvent extends BaseEvent {
  final dynamic msg;

  MessageEvent({
    this.msg,
  });
}

class ErrorEvent extends BaseEvent {
  final dynamic error;

  ErrorEvent({
    this.error,
  });
}

class LoadingEvent extends BaseEvent {
  final bool isLoading;
  final bool hasBlurBackground;
  final dynamic message;

  LoadingEvent({
    required this.isLoading,
    this.hasBlurBackground = true,
    this.message,
  });
}

class ShowDialogEvent extends BaseEvent {
  final Widget Function(BuildContext context) builder;
  final bool dismissable;
  ShowDialogEvent({
    required this.builder,
    this.dismissable = false,
  });
}
