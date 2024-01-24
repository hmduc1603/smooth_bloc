
<div align="center">
  <img src="https://github.com/hmduc1603/smooth_bloc/raw/main/assets/smooth_bloc_icon.png" width="400"/>
</div>

---

A `State Managament Code Base` (based on [flutter_bloc](https://pub.dev/packages/flutter_bloc)) that helps effortlessly & easily implement [BLoC pattern](https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc) for **production quality and maintenance**.

There are various ways to implement [flutter_bloc](https://pub.dev/packages/flutter_bloc) for a screen, sometime newcomers get lost into finding a best solution. Thus, this package aims to give **simplest code base** for implementating 3 differents layers in a screen (ex: Logic, View, Data/State) and easily use it without exploring in all [flutter_bloc](https://pub.dev/packages/flutter_bloc) features, which we don't usually use all of them in production's cases. 

This package is stably used in more than 20 author's enterprise applications and still counting.

This package is built to work with:

- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [equatable](https://pub.dev/packages/equatable)

## Main Features

Here's some main features:

1. State management (Of course!)
2. Highly customized event based functions: 
  - Show loading page
  - Show error dialog
  - Show message dialog
3. Listen to state changed
4. Easily control rebuilding's conditions
  

## Overview

<div align="center">
  <img src="https://github.com/hmduc1603/smooth_bloc/raw/main/assets/smooth_bloc_overview.png" width="300"/>
</div>


A screen/feature in [Smooth Bloc](https://pub.dev/packages/smooth_bloc) will contains 3 `Dart` classes:

`Cubit`: This class holds your logics that user interact on the View and you can control when/how the View should rebuild.

`State`: This class includes properties displayed in View and could be changed overtime by Cubit class.

`View`: This class holds all of your widgets, and will automatically rebuild whenever State is changed. The View usually call Cubit's functions.

## Installation

```
dependencies:  
  # add copy_with_extension (Optional)
  copy_with_extension:  
  # add smooth_bloc
  smooth_bloc:
  
dev_dependencies:  
  # add copy_with_extension_gen (Optional)
  copy_with_extension_gen:
```

## How To Use

### First Setup

[Smooth Bloc](https://pub.dev/packages/smooth_bloc) allows customize Dialog & Loading Screen if you want.

```
void main() {
  // Setup SmoothBloc
  SmoothBloc().setUp(
    appLoadingBuilder: (message) {
      // Return your customized Widget here
    },
    appDialogBuilder: (message) {
      // Return your customized Widget here
    },
  );

  // Configure getIt here (https://pub.dev/packages/injectable)
  configureDependencies();

  // Run App
  runApp(const TestApp());
}
```


### Creating State Class

<div align="center">
  <img src="https://github.com/hmduc1603/smooth_bloc/raw/main/assets/smooth_bloc_state.png" width="150"/>
</div>

Classes that extends `BaseState` need to implement getter value of `stateComparisonProps` which declares props used to compare & identify when should the view need rebuild (when state are changed!)

You can use [copy_with_extension](https://pub.dev/packages/copy_with_extension) to help generate copyWith() function. It's very useful in Cubit's logical functions.

```dart
part 'login_state.g.dart';

//@CopyWith() is an optional annotation
@CopyWith()
class LoginState extends BaseState {
  final bool isLoggedIn;

  // Constructor need to declare default const for all props
  LoginState({
     this.isLoggedIn = false,
  });

  @override
  List<Object?> get stateComparisonProps => [
        isLoggedIn,
      ];
}
```

### Creating Cubit Class

<div align="center">
  <img src="https://github.com/hmduc1603/smooth_bloc/raw/main/assets/smooth_bloc_cubit.png" width="280"/>
</div>

Classes that extends from `BaseCubit` will inherit above functions and props.

```
import 'login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit() : super(LoginState());

  void login(String email, password) {
    try {
      // Call to show loading screen
      showLoading();
      // Assumme that your have completed authenticate user
      // Call emit function to change state and trigger screen rebuilding
      emit(
        state.copyWith(
          isLoggedIn: true,
        ),
      );
      // You could show message to user
      showMessage("You've been logged in!");
    } catch (e) {
      // Show error dialog on screen
      handleError(e.toString());
    } finally {
      // Call to hide loading screen
      hideLoading();
    }
  }
}

@override
  Future<void> close() {
    // Anything here you want to dispose/close/cancel with the cubit
    return super.close();
  }
```

Additionally, you can make use of `eventStreamController` to fire any customized event class (extended from `BaseEvent`), and the View can listen to it!.

For example, if you want to create an event that trigger view to navigate to another view.

```
/// Create an event class
class PushPageEvent extends BaseEvent {
  final String routeName;
  PushPageEvent({
    required this.routeName,
  });
}
```

```
/// Then use in Cubit
void signOut() {
    // Signing user out
    // Return to some screen
    eventStreamController.add(PushPageEvent(routeName: "main"));
  }
```

```
/// In View, hanlde like this
@override
  onNewEvent(BaseEvent event) {
    if (event is PushPageEvent) {
      final routeName = event.routeName;
      // Push new view
    }
    return super.onNewEvent(event);
  }
```


### Creating View Class

<div align="center">
  <img src="https://github.com/hmduc1603/smooth_bloc/raw/main/assets/smooth_bloc_view.png" width="140"/>
</div>

Classes that extends from `BaseView` will inherit above functions.

```
import 'login_cubit.dart';
import 'login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseView<LoginState, LoginCubit, LoginView> {
  @override
  LoginCubit assignCubit() {
    // Example return using dependency injection
    return GetIt.instance<LoginCubit>();
    // Or return as a constant value
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
    // Handle your customized event here
    if (event is PushPageEvent) {
      final routeName = event.routeName;
      // Ex: Push new view
    }
    return super.onNewEvent(event);
  }

  @override
  bool shouldRebuild(LoginState previous, LoginState current) {
    // Declare any conditions that allow or not allow view to rebuild
    return super.shouldRebuild(previous, current);
  }

  @override
  onStateChanged(LoginState previous, LoginState current) {
    // Observe to state changes here!
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
    return Scaffold(
      body: Center(
        child: Column(
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
          ],
        ),
      ),
    );
  }
}
```

### Some Notes

Remeber to run build_runner to generate essential components (@CopyWith, @injectable) before run the app.
```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

