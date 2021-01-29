import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia implements Equatable {
  NumberTriviaModel({
    @required String text,
    @required int number,
  }) : super(number: number, text: text);

  @override
  toString() => 'NumberTriviaModel: $text $number';

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) =>
      NumberTriviaModel(
        text: json['text'],
        number: (json['number'] as num).toInt(),
      );

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
