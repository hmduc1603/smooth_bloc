import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  /// Declare props will be used to compare & identify when should the view need rebuild (as they are changed!)
  List<Object?> get stateComparisonProps;

  @override
  List<Object?> get props => stateComparisonProps;
}
