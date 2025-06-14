import 'package:caronsale/core/utils/failures.dart';

/// Utility class that simplifies handling errors.
///
/// Return a [Result] from a function to indicate success or failure.
///
/// A [Result] is either an [Ok] with a value of type [T]
/// or an [Error] with an [Exception].
///
/// Use [Result.ok] to create a successful result with a value of type [T].
/// Use [Result.error] to create an error result with an [Exception].
sealed class Result<T> {
  const Result();

  /// Creates an instance of Result containing a value
  factory Result.ok(T value) => Ok(value);

  /// Create an instance of Result containing an error
  factory Result.error(Failure error) => Error(error);

  B fold<B>(B Function(Failure l) ifLeft, B Function(T r) ifRight);
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  /// Returned value in result
  final T value;

  @override
  B fold<B>(B Function(Failure l) ifLeft, B Function(T r) ifRight) =>
      ifRight(value);
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error(this.error);

  /// Returned error in result
  final Failure error;

  @override
  B fold<B>(B Function(Failure l) ifLeft, B Function(T r) ifRight) =>
      ifLeft(error);
}
