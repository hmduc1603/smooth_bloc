// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';
import 'package:smooth_bloc/smooth_bloc.dart';

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

  void signOut() {
    // Signing user out
    // Return to some screen
    eventStreamController.add(PushPageEvent(routeName: "main"));
  }

  @override
  Future<void> close() {
    // Anything here you want to dispose/close/cancel with the cubit
    return super.close();
  }
}

class PushPageEvent extends BaseEvent {
  final String routeName;
  PushPageEvent({
    required this.routeName,
  });
}
