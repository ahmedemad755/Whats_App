abstract class Failure {
  const Failure([this.message = '']);
  final String message;
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Something went wrong. Please try again.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Unable to connect. Check your connection.']);
}
