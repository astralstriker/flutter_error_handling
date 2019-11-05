import 'package:meta/meta.dart';

@sealed
abstract class ApiException {
  StackTrace _stackTrace;
  String _message;

  ApiException(String message, [StackTrace stackTrace])
      : _message = message,
        _stackTrace = stackTrace;

  @override
  String toString() => _message;

  dynamic when<R>({
    void Function(NoNetworkException) noNetworkException,
    void Function(NotFoundException) notFoundException,
    void Function(UnauthorizedException) unauthorizedException,
    void Function(CustomException) customException,
  }) {
    if (this is NoNetworkException) {
      return noNetworkException(this as NoNetworkException);
    } else if (this is NotFoundException) {
      return notFoundException(this as NotFoundException);
    } else if (this is UnauthorizedException) {
      return unauthorizedException(this as UnauthorizedException);
    } else if (this is CustomException) {
      return customException(this as CustomException);
    } else {
      throw new Exception('Unhendled part, could be anything');
    }
  }
}

class NoNetworkException extends ApiException {
  NoNetworkException() : super("No network");
}

class NotFoundException extends ApiException {
  NotFoundException() : super("no such api");
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super("User unauthorized");
}

class CustomException extends ApiException {
  CustomException(String message) : super(message);
}
