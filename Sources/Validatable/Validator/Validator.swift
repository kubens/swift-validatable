/// Validates values of a specific type.
public struct Validator<Value> {

  /// Validates a value against the configured rules.
  ///
  /// - Parameter value: The value to validate.
  /// - Returns: The validation results.
  let validate: (Value) -> ValidatorResult

  init(validate: @escaping (Value) -> ValidatorResult) {
    self.validate = validate
  }

  /// Creates a validator that fails with the specified reason when the predicate is not satisfied.
  ///
  /// - Parameters:
  ///   - reason: The reason reported when validation fails.
  ///   - predicate: A predicate that determines whether the value is valid.
  init(_ reason: String, satisfies predicate: @escaping (Value) -> Bool) {
    self.init { value in
      predicate(value) ? .success : .failure(.init(reason: reason))
    }
  }
}
