extension Validator where Value: Comparable, Value: AdditiveArithmetic {

  /// Validates that a value is greater than zero.
  public static var positive: Self {
    Validator("must be positive") { $0 > .zero }
  }

  /// Validates that a value is less than zero.
  public static var negative: Self {
    Validator("must be negative") { $0 < .zero }
  }

  /// Validates that a value is greater than or equal to zero.
  public static var nonNegative: Self {
    Validator("must be non-negative") { $0 >= .zero }
  }

  /// Validates that a value is less than or equal to zero.
  public static var nonPositive: Self {
    Validator("must be non-positive") { $0 <= .zero }
  }

  /// Validates that a value is greater than or equal to the specified minimum.
  ///
  /// - Parameter min: The minimum allowed value.
  public static func min(_ min: Value) -> Self {
    Validator("must be at least \(min)") { $0 >= min }
  }

  /// Validates that a value is less than or equal to the specified maximum.
  ///
  /// - Parameter max: The maximum allowed value.
  public static func max(_ max: Value) -> Self {
    Validator("must be at most \(max)") { $0 <= max }
  }
}
