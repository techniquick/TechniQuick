abstract class Failure {}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class AuthFailure extends Failure {
  final String message;
  AuthFailure({required this.message});
}

class NoCachedUserFailure extends Failure {}

class ResetPasswordFailure extends Failure {}

class StatusFailure extends Failure {
  final String message;
  StatusFailure({required this.message});
}

class FirebaseFailure extends Failure {
  final String message;
  FirebaseFailure({required this.message});
}
