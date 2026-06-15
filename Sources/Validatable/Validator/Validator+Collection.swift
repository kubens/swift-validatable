/// Validators for collection values.
///
/// These validators work with any `Collection`, including strings, arrays, sets, and dictionaries.
/// They validate `isEmpty` or `count`, depending on the rule.
///
/// ```swift
/// struct Profile: Validatable {
///   let username: String
///   let tags: [String]
///
///   static func validations(_ collector: inout Validations<Self>) {
///     collector.add(\.username, is: .nonEmpty, .min(3))
///     collector.add(\.tags, is: .nonEmpty, .max(5))
///   }
/// }
/// ```
extension Validator where Value: Collection {

  /// Validates that a collection is not empty.
  ///
  /// This validator checks `isEmpty`, so it can be used for strings as well as other collections.
  ///
  /// ```swift
  /// collector.add(\.name, is: .nonEmpty)
  /// collector.add(\.tags, is: .nonEmpty)
  /// ```
  public static var nonEmpty: Self {
    Validator("value cannot be empty") { !$0.isEmpty }
  }

  /// Validates that a collection contains at least the specified number of elements.
  ///
  /// For strings, the minimum is measured using `String.count`.
  ///
  /// ```swift
  /// collector.add(\.username, is: .min(3))
  /// collector.add(\.tags, is: .min(1))
  /// ```
  ///
  /// - Parameter min: The minimum number of elements required.
  public static func min(_ min: Int) -> Self {
    Validator("count must be at least \(min)") { $0.count >= min }
  }

  /// Validates that a collection contains at most the specified number of elements.
  ///
  /// Use this validator to limit lengths, such as a maximum username length or maximum number of
  /// selected tags.
  ///
  /// ```swift
  /// collector.add(\.username, is: .max(20))
  /// collector.add(\.tags, is: .max(5))
  /// ```
  ///
  /// - Parameter max: The maximum number of elements allowed.
  public static func max(_ max: Int) -> Self {
    Validator("count must be at most \(max)") { $0.count <= max }
  }

  /// Validates that a collection contains exactly the specified number of elements.
  ///
  /// Use this validator when a field must have a fixed length or exact number of values.
  ///
  /// ```swift
  /// collector.add(\.verificationCode, is: .count(6))
  /// collector.add(\.selectedOptions, is: .count(3))
  /// ```
  ///
  /// - Parameter count: The required number of elements.
  public static func count(_ count: Int) -> Self {
    Validator("count must be exactly \(count)") { $0.count == count }
  }
}
