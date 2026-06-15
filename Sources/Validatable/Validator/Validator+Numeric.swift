/// Validators for numeric-like values that can be compared with zero.
///
/// These validators work with values that conform to both `Comparable` and `AdditiveArithmetic`,
/// such as `Int`, `Double`, and other numeric types with a `.zero` value.
///
/// ```swift
/// struct Product: Validatable {
///   let price: Decimal
///   let stock: Int
///
///   static func validations(_ collector: inout Validations<Self>) {
///     collector.add(\.price, is: .positive)
///     collector.add(\.stock, is: .nonNegative, .max(100))
///   }
/// }
/// ```
extension Validator where Value: Comparable, Value: AdditiveArithmetic {

  /// Validates that a value is greater than zero.
  ///
  /// ```swift
  /// collector.add(\.price, is: .positive)
  /// ```
  public static var positive: Self {
    Validator("must be positive") { $0 > .zero }
  }

  /// Validates that a value is less than zero.
  ///
  /// ```swift
  /// collector.add(\.balance, is: .negative)
  /// ```
  public static var negative: Self {
    Validator("must be negative") { $0 < .zero }
  }

  /// Validates that a value is greater than or equal to zero.
  ///
  /// Use this validator for values where zero is allowed, such as counts or stock levels.
  ///
  /// ```swift
  /// collector.add(\.stock, is: .nonNegative)
  /// ```
  public static var nonNegative: Self {
    Validator("must be non-negative") { $0 >= .zero }
  }

  /// Validates that a value is less than or equal to zero.
  ///
  /// ```swift
  /// collector.add(\.offset, is: .nonPositive)
  /// ```
  public static var nonPositive: Self {
    Validator("must be non-positive") { $0 <= .zero }
  }

  /// Validates that a value is greater than or equal to the specified minimum.
  ///
  /// ```swift
  /// collector.add(\.quantity, is: .min(1))
  /// ```
  ///
  /// - Parameter min: The minimum allowed value.
  public static func min(_ min: Value) -> Self {
    Validator("must be at least \(min)") { $0 >= min }
  }

  /// Validates that a value is less than or equal to the specified maximum.
  ///
  /// ```swift
  /// collector.add(\.quantity, is: .max(100))
  /// ```
  ///
  /// - Parameter max: The maximum allowed value.
  public static func max(_ max: Value) -> Self {
    Validator("must be at most \(max)") { $0 <= max }
  }
}
