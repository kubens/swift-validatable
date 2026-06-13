extension Validator where Value: Collection {

  /// Validates that a collection is not empty.
  public static var nonEmpty: Self {
    Validator("value cannot be empty") { !$0.isEmpty }
  }

  /// Validates that a collection contains at least the specified number of elements.
  ///
  /// - Parameter min: The minimum number of elements required.
  public static func min(_ min: Int) -> Self {
    Validator("count must be at least \(min)") { $0.count >= min }
  }

  /// Validates that a collection contains at most the specified number of elements.
  ///
  /// - Parameter max: The maximum number of elements allowed.
  public static func max(_ max: Int) -> Self {
    Validator("count must be at most \(max)") { $0.count <= max }
  }

  /// Validates that a collection contains exactly the specified number of elements.
  ///
  /// - Parameter count: The required number of elements.
  public static func count(_ count: Int) -> Self {
    Validator("count must be exactly \(count)") { $0.count == count }
  }
}
