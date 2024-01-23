library smooth_bloc;

export 'sources/statemanagement.dart';
export 'sources/base_event.dart';
export 'sources/base_cubit.dart';
export 'sources/base_state.dart';
export 'sources/base_view.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
