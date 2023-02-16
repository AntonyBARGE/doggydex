import 'package:equatable/equatable.dart';

abstract class DogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConcreteDogEvent extends DogEvent {
  final String numberString;

  GetConcreteDogEvent(this.numberString);

  @override
  List<Object> get props => [numberString];
}

class GetRandomDogEvent extends DogEvent {}
