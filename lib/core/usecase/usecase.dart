import 'package:equatable/equatable.dart';

import '../utils/result.dart';

/// Base contract for every use case in the domain layer.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Used by use cases that don't need any input.
final class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
