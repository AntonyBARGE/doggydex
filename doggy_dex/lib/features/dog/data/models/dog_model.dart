
import '../../domain/entities/dog.dart';

class DogModel extends Dog {
  const DogModel({
    required String text,
    required int number,
  }) : super(text: text, number: number);

  factory DogModel.fromJson(Map<String, dynamic> json) {
    return DogModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
