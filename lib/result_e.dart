import 'package:meta/meta.dart';

enum _ResponseState {
  Success,
  MalformedDataError,
  NullResponseError,
}

@immutable
@sealed
abstract class Result<T> {
  final T value;
  final _ResponseState _state;

  const Result(this.value, _ResponseState state) : _state = state;

  when<R>({
    R Function(Success) onSuccess,
    R Function(MalformedDataError) onMalformedDataError,
    R Function(NullResponseError) onNullResponseError,
  }) {
    switch (this._state) {
      case _ResponseState.Success:
        return onSuccess(this as Success);
      case _ResponseState.MalformedDataError:
        return onMalformedDataError(this as MalformedDataError);
      case _ResponseState.NullResponseError:
        return onNullResponseError(this as NullResponseError);
    }
  }
}

class Success<T> extends Result<T> {
  const Success(T value) : super(value, _ResponseState.Success);
}

class MalformedDataError extends Result {
  const MalformedDataError()
      : super("aaaaa", _ResponseState.MalformedDataError);
}

class NullResponseError extends Result {
  const NullResponseError() : super("bbbbb", _ResponseState.NullResponseError);
}
