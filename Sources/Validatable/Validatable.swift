/// A type that defines validation rules for its values.
///
/// Conform to `Validatable` by adding rules to the provided ``Validations`` collector. Call
/// ``validate()`` on an instance to evaluate those rules and throw ``ValidationError`` when any
/// rule fails.
///
/// ```swift
/// struct User: Validatable {
///   let email: String
///   let age: Int
///
///   static func validations(_ collector: inout Validations<Self>) {
///     collector.add(\.email, is: .nonEmpty, .email)
///     collector.add(\.age, is: .min(18))
///   }
/// }
///
/// try User(email: "user@example.com", age: 21).validate()
/// ```
public protocol Validatable {

  /// Adds validation rules for the conforming type.
  ///
  /// Implement this method by adding property-level validators and item-level predicates to
  /// `collector`. The default ``validate()`` implementation calls this method for the value being
  /// validated.
  ///
  /// - Parameter collector: The validation collector to configure.
  static func validations(_ collector: inout Validations<Self>)

  /// Validates the current value.
  ///
  /// - Throws: ``ValidationError`` when one or more configured validation rules fail.
  func validate() throws
}

extension Validatable {

  /// Validates the current value using the rules defined by ``validations(_:)``.
  ///
  /// This implementation collects validation results, converts failures into a ``ValidationError``,
  /// and returns normally when all rules pass.
  ///
  /// - Throws: ``ValidationError`` when one or more configured validation rules fail.
  public func validate() throws {
    var validations = Validations(self)
    Self.validations(&validations)

    let failures = validations.failures
    guard failures.isEmpty else {
      throw ValidationError(
        reasons: failures.reduce(into: [:]) { partial, entry in
          partial[entry.key] = entry.value.map(\.reason)
        })
    }
  }
}
