part of 'dog_bloc.dart';

abstract class DogState extends Equatable {
  const DogState();

  @override
  List<Object> get props => [];
}

class Empty extends DogState {}

class Loading extends DogState {}

class Loaded extends DogState {
  final Dog dog;

  const Loaded({required this.dog});
}

class Error extends DogState {
  final String message;

  const Error({required this.message});
}
