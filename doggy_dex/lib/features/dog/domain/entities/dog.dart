import 'package:equatable/equatable.dart';

class Dog extends Equatable {
  final String text;
  final int number;

  const Dog({
    required this.text,
    required this.number,
  });

  @override
  List<Object> get props => [text, number];
}
