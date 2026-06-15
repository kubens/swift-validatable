/// The result returned by a validator.
///
/// Validators return `.success` when a value satisfies a rule and `.failure(_:)` when it does not.
/// You usually work with this type when creating custom validators with
/// ``Validator/init(validate:)``.
///
/// ```swift
/// let maximum = Validator<Int> { value in
///   value <= 10 ? .success : .failure(.init(reason: "must be at most 10"))
/// }
/// ```
public enum ValidatorResult: Sendable {

  /// Information about a failed validation.
  public struct Failure: Error, Sendable {

    /// A human-readable explanation of why validation failed.
    public let reason: String
  }

  /// Indicates that validation succeeded.
  case success

  /// Indicates that validation failed.
  ///
  /// - Parameter failure: Information about the validation failure.
  case failure(Failure)
}
