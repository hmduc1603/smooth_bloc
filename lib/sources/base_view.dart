import 'dart:async';
import 'package:smooth_bloc/sources/base_cubit.dart';
import 'package:smooth_bloc/sources/base_event.dart';
import 'package:smooth_bloc/sources/base_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_bloc/sources/base_state.dart';
import 'package:smooth_bloc/sources/statemanagement.dart';
import 'base_app_loading.dart';

abstract class BaseView<S extends BaseState, C extends BaseCubit<S>,
        W extends StatefulWidget> extends State<W>
    with AutomaticKeepAliveClientMixin {
  final C cubit = GetIt.instance<C>();
  final loadingController = AppLoadingController();
  late S _state;
  StreamSubscription? _eventStreamSub;

  S get state => _state;

  // Use when you want to maintain Cubit & State
  bool get shouldMaintainState => false;

  @override
  void initState() {
    super.initState();
    _state = cubit.state;
    _eventStreamSub = cubit.eventStream.listen(
      (value) => onNewEvent(value),
    );
  }

  @override
  void dispose() {
    if (!shouldMaintainState) {
      _eventStreamSub?.cancel();
      cubit.close();
    }
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: cubit,
      child: BlocListener<C, S>(
        listenWhen: (S previous, S current) {
          onStateChanged(previous, current);
          return shouldRebuild(previous, current);
        },
        listener: (context, state) => setState(() => _state = state),
        child: AppLoadingHUD(
            controller: loadingController,
            child: buildByState(context, _state)),
      ),
    );
  }

  Widget buildByState(BuildContext context, S state);

  onStateChanged(S previous, S current) {}

  bool shouldRebuild(S previous, S current) {
    return true;
  }

  onNewEvent(BaseEvent event) {
    if (!mounted) {
      return;
    }
    if (event is LoadingEvent) {
      event.isLoading
          ? loadingController.showLoading(
              blurBG: event.hasBlurBackground, msg: getMessage(event.message))
          : loadingController.hideLoading();
    } else if (event is MessageEvent) {
      showMessage(getMessage(event.msg));
    } else if (event is ErrorEvent) {
      showError(getErrorMessage(event.error));
    } else if (event is ShowDialogEvent) {
      showDialog(
        barrierDismissible: event.dismissable,
        context: context,
        builder: (context) {
          return event.builder(context);
        },
      );
    }
  }

  String getErrorMessage(error) {
    if (error is BaseMessage) {
      return error.localized(context);
    }
    if (error != null) {
      return error.toString();
    }
    return 'Something wrong is happened, please try again';
  }

  String getMessage(msg) {
    if (msg is BaseMessage) {
      return msg.localized(context);
    }
    if (msg != null) {
      return msg;
    }
    return '';
  }

  Future<void> showMessage(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return StateManagement().appDialogBuilder(message);
      },
    );
  }

  showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return StateManagement().appDialogBuilder(message);
      },
    );
  }
}
