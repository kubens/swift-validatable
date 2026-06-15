/// A reusable validation rule for values of a specific type.
///
/// A validator evaluates one value and returns a `ValidatorResult`. Use the built-in validators
/// from the type-specific extensions, or create custom validators for domain-specific rules.
///
/// ```swift
/// let even = Validator<Int>("must be even") { $0.isMultiple(of: 2) }
/// let result = even.validate(3)
/// ```
///
/// Define custom validators in extensions when you want to reuse them in a validation collector:
///
/// ```swift
/// extension Validator where Value == Int {
///   static var even: Self {
///     Validator("must be even") { $0.isMultiple(of: 2) }
///   }
/// }
///
/// struct Ticket: Validatable {
///   let seats: Int
///
///   static func validations(_ collector: inout Validations<Self>) {
///     collector.add(\.seats, is: .positive, .even)
///   }
/// }
/// ```
public struct Validator<Value> {

  /// Validates a value against the configured rules.
  ///
  /// - Parameter value: The value to validate.
  /// - Returns: The validation results.
  public let validate: (Value) -> ValidatorResult

  /// Creates a validator with a closure that returns a complete validation result.
  ///
  /// Use this initializer when the validation logic needs to choose the full `ValidatorResult`.
  /// For simple pass-or-fail predicates, prefer `init(_:satisfies:)`.
  ///
  /// For example, return a custom result from the validation closure:
  ///
  /// ```swift
  /// let maximum = Validator<Int> { value in
  ///   value <= 10 ? .success : .failure(.init(reason: "must be at most 10"))
  /// }
  /// ```
  ///
  /// - Parameter validate: A closure that validates a value and returns the result.
  public init(validate: @escaping (Value) -> ValidatorResult) {
    self.validate = validate
  }

  /// Creates a validator that fails with the specified reason when the predicate is not satisfied.
  ///
  /// For example, create a validator from a failure reason and a Boolean predicate:
  ///
  /// ```swift
  /// let even = Validator<Int>("must be even") { $0.isMultiple(of: 2) }
  /// ```
  ///
  /// - Parameters:
  ///   - reason: The reason reported when validation fails.
  ///   - predicate: A predicate that determines whether the value is valid.
  public init(_ reason: String, satisfies predicate: @escaping (Value) -> Bool) {
    self.init { value in
      predicate(value) ? .success : .failure(.init(reason: reason))
    }
  }
}
