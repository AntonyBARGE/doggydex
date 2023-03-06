part of 'dog_bloc.dart';

abstract class DogEvent extends Equatable {
  const DogEvent();

  @override
  List<Object> get props => [];
}

class GetConcreteDogEvent extends DogEvent {
  final String numberString;

  const GetConcreteDogEvent(this.numberString);
}

class GetRandomDogEvent extends DogEvent {}
