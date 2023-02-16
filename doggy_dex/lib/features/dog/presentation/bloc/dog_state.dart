import 'package:equatable/equatable.dart';

import '../../domain/entities/dog.dart';

abstract class DogState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends DogState {}

class Loading extends DogState {}

class Loaded extends DogState {
  final Dog trivia;

  Loaded({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class Error extends DogState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
