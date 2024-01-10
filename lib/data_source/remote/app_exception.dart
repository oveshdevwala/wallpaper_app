// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppExecption implements Exception {
  String title;
  String body;
  AppExecption({
    required this.title,
    required this.body,
  });

  String toErrorMassage() => '$title : $body';
}

class FetchDataExecption extends AppExecption {
  FetchDataExecption({required String body})
      : super(title: 'Error During Communication', body: body);
}

class BadRequestExecption extends AppExecption {
  BadRequestExecption({required String body})
      : super(title: 'Invalid Request', body: body);
}

class UnauthorizedExecption extends AppExecption {
  UnauthorizedExecption({required String body})
      : super(title: 'Unauthorized', body: body);
}

class InvalidInputException extends AppExecption {
  InvalidInputException({required String body})
      : super(body: body, title: 'Invalid Input');
}
