// ignore: unnecessary_import
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:smooth_bloc/sources/base_state.dart';

part 'login_state.g.dart';

@CopyWith()
class LoginState extends BaseState {
  final bool isLoggedIn;
  LoginState({
    this.isLoggedIn = false,
  });

  @override
  List<Object?> get stateComparisonProps => [
        isLoggedIn,
      ];
}
