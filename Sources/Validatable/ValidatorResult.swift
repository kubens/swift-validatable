/// The result of a validation.
public enum ValidatorResult: Sendable {

  /// A validation failure.
  public struct Failure: Error, Sendable {

    /// The reason the validation failed.
    public let reason: String
  }

  /// Indicates that validation succeeded.
  case success

  /// Indicates that validation failed.
  ///
  /// - Parameter failure: Information about the validation failure.
  case failure(Failure)
}
