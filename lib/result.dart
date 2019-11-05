import 'package:meta/meta.dart';

@sealed
abstract class Result<
T> {
  final T value;
  Result(this.value);

  R when<R>(
      R Function(Success<T>) success,
      R Function(MalformedResultError) malformedResultError,
      R Function(NullResultError) nullResultError,
      ) {
    if (this is Success<T>) {
      return success(this as Success<T>);
    } else if (this is MalformedResultError) {
      return malformedResultError(this as MalformedResultError);
    }
    else if(this is NullResultError){
      return nullResultError(this as NullResultError);
    }
    else {
      throw new Exception('Unhendled part, could be anything');
    }
  }
}

class Success<T> extends Result<T> {
  Success(T value) : super(value);
}

class MalformedResultError extends Result {
  MalformedResultError() : super("Result was malformed");
}

class NullResultError extends Result {
  NullResultError() : super("Result was null");
}
