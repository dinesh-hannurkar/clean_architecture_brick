import 'package:fpdart/fpdart.dart';
import 'package:{{project_name}}/core/domain/failures/failure.dart';

/// Base class for all use cases in the application.
///
/// Use cases represent single business operations and follow the
/// Single Responsibility Principle. Each use case should do one thing well.
///
/// Type parameters:
/// - [Result]: The success return type
/// - [Params]: The parameters required for this use case
abstract class UseCase<Result, Params> {
  /// Executes the use case with the given [params].
  ///
  /// Returns [Either] a [Failure] or the success value of type [Result].
  Future<Either<Failure, Result>> call(Params params);
}

/// Marker class for use cases that don't require parameters.
///
/// Use this when your use case doesn't need any input.
class NoParams {
  /// Creates a [NoParams] instance.
  const NoParams();
}
