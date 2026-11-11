import '../error/exceptions.dart';
import '../error/failures.dart';

/// A value that is either a [Success] holding data or a [Failed]
/// holding a [Failure]. Returned by every repository and use case.
sealed class Result<T> {
  const Result();

  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Failed<T>(:final failure) => onFailure(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;
}

/// Runs [action] and maps any [AppException] to the matching [Failure].
Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } on AppException catch (e) {
    return Failed(switch (e) {
      ServerException() => ServerFailure(e.message),
      CacheException() => CacheFailure(e.message),
      AuthException() => AuthFailure(e.message),
    });
  } catch (_) {
    return const Failed(UnexpectedFailure());
  }
}
