import 'package:demo_smooth_bloc/di/injector.dart';
import 'package:demo_smooth_bloc/login_view/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:smooth_bloc/smooth_bloc.dart';
import 'package:get_it/get_it.dart';

import 'login_view/login_state.dart';

void main() {
  SmoothBloc().setUp();

  // I use GetIt
  configureDependencies();

  runApp(const LoginView());
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseView<LoginState, LoginCubit, LoginView> {
  @override
  LoginCubit assignCubit() {
    // Return using dependency injection
    return GetIt.instance<LoginCubit>();
    // Or return as a constant value (Note that if the view is disposed, Cubit class is also disposed)
    return LoginCubit();
  }

  // If TRUE, the Cubit close() function will not be called when View is disposed
  // Default is FALSE
  @override
  bool get shouldNotDisposeCubitAndState => false;

  // This is from AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  onNewEvent(BaseEvent event) {
    if (event is PushPageEvent) {
      // ignore: unused_local_variable
      final routeName = event.routeName;
      // Push new view
    }
    return super.onNewEvent(event);
  }

  @override
  bool shouldRebuild(LoginState previous, LoginState current) {
    // Any conditions that allow or not allow view to rebuild
    return super.shouldRebuild(previous, current);
  }

  @override
  onStateChanged(LoginState previous, LoginState current) {
    if (previous.isLoggedIn != current.isLoggedIn && current.isLoggedIn) {
      // Ex: Push to home screen
    }
    return super.onStateChanged(previous, current);
  }

  @override
  String getErrorMessage(error) {
    // You can customize error event (fired from Cubit) here
    // Most common usage is localization
    return super.getErrorMessage(error);
  }

  @override
  String getMessage(msg) {
    // You can customize message event (fired from Cubit) here
    // Most common usage is localization
    return super.getMessage(msg);
  }

  @override
  Widget buildByState(BuildContext context, LoginState state) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.isLoggedIn ? "You're logged in" : "Please sign in!",
              ),
              ElevatedButton(
                onPressed: () {
                  cubit.login("email", "password");
                },
                child: const Text("Login"),
              ),
              ElevatedButton(
                onPressed: () {
                  cubit.signOut();
                },
                child: const Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
