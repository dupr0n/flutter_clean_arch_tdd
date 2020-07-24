part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetNumberTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  @override
  List<Object> get props => [numberString];

  GetNumberTriviaForConcreteNumber(this.numberString);
}

class GetNumberTriviaForRandomNumber extends NumberTriviaEvent {
  @override
  List<Object> get props => [];
}
