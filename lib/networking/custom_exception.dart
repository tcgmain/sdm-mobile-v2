// ignore_for_file: prefer_typing_uninitialized_variables, annotate_overrides


class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message]): super(message, "");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised");
}

class InvalidCredentials extends CustomException {
  InvalidCredentials([message]) : super(message, "Invalid Username or Password");
}

class NotFound extends CustomException {
  NotFound([message]) : super(message, "");
}

class NoRecordsFound extends CustomException {
  NoRecordsFound([message]) : super(message, "No Records Found");
}

class AbasException extends CustomException {
  AbasException([message]) : super(message, "Fail to load");
}

class UndefinedError extends CustomException {
  UndefinedError([message]) : super(message, "Undefined Error");
}