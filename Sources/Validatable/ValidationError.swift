/// An error containing validation failure reasons grouped by validation target.
///
/// `validate()` throws this error when one or more rules fail. Inspect ``reasons`` to present or
/// log field-specific validation messages.
///
/// ```swift
/// do {
///   try user.validate()
/// } catch let error as ValidationError {
///   print(error.reasons)
/// }
/// ```
public struct ValidationError: Error {

  /// Validation failure reasons grouped by validation target.
  ///
  /// Property-level validations are grouped by the property's name. Item-level validations are
  /// grouped by the validated type's name.
  public let reasons: [String: [String]]
}
