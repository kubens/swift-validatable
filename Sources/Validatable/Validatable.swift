/// A type that can be validated.
public protocol Validatable {

  /// Adds validation rules for the conforming type.
  ///
  /// - Parameter collector: The validation collector to configure.
  static func validations(_ collector: inout Validations<Self>)

  /// Validates the current value.
  ///
  /// - Throws: A validation error if validation fails.
  func validate() throws
}

extension Validatable {

  /// Validates the current value.
  ///
  /// - Throws: A validation error if validation fails.
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
