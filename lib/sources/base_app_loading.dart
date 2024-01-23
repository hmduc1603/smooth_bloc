import 'package:flutter/material.dart';
import 'package:smooth_bloc/sources/statemanagement.dart';

class AppLoadingController {
  final params = ValueNotifier<AppLoadingControllerParams>(
    AppLoadingControllerParams(
        visible: false, hasBlurBackground: true, message: null),
  );

  showLoading({bool blurBG = true, String? msg}) {
    params.value = params.value.copyWith(
      visible: true,
      hasBlurBackground: blurBG,
      message: msg,
    );
  }

  hideLoading() {
    params.value = params.value.copyWith(visible: false);
  }
}

class AppLoadingControllerParams {
  final bool visible;
  final bool hasBlurBackground;
  final String? message;

  AppLoadingControllerParams({
    required this.visible,
    required this.hasBlurBackground,
    required this.message,
  });

  AppLoadingControllerParams copyWith({
    bool? visible,
    bool? hasBlurBackground,
    String? message,
  }) {
    return AppLoadingControllerParams(
      visible: visible ?? this.visible,
      hasBlurBackground: hasBlurBackground ?? this.hasBlurBackground,
      message: message ?? this.message,
    );
  }
}

class AppLoadingHUD extends StatelessWidget {
  const AppLoadingHUD({Key? key, required this.child, required this.controller})
      : super(key: key);

  final Widget child;
  final AppLoadingController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder<AppLoadingControllerParams>(
            valueListenable: controller.params,
            builder: (context, visible, child) {
              return Visibility(
                visible: controller.params.value.visible,
                child: SmoothBloc()
                    .appLoadingBuilder(controller.params.value.message ?? ''),
              );
            })
      ],
    );
  }
}
