//LOGIN EXCEPTION
class UserNotFoundAuthException implements Exception {}

class WorngPasswordAuthException implements Exception {}

//REGISTER EXCEPTION
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//GENERIC EXCEPTIONS
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
