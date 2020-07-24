import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String str) {
    final intValue = int.tryParse(str);
    return (intValue == null || intValue.isNegative)
        ? Left(InvalidInputFailure())
        : Right(intValue);
  }
}

class InvalidInputFailure extends Failure {}
