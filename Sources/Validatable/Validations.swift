/// Collects validation results for a single item.
///
/// `Validations` is the collector passed to `Validatable.validations(_:)`. Use it to define
/// property-level validators and item-level predicates for a `Validatable` type.
///
/// For example, define validations for a range input and run them with `validate()`:
///
/// ```swift
/// struct RangeInput: Validatable {
///   let start: Int
///   let end: Int
///
///   static func validations(_ collector: inout Validations<Self>) {
///     collector.add(\.start, is: .min(0))
///     collector.add(\.end, is: .min(0))
///     collector.add("start must be before end") { $0.start < $0.end }
///   }
/// }
///
/// try RangeInput(start: 10, end: 5).validate()
/// ```
public struct Validations<Item> {

  /// The item being validated.
  private let item: Item

  /// All validation results grouped by validation target.
  ///
  /// Property-level validations are stored under the key path's final component. Item-level
  /// validations are stored under the validated item's type name.
  public private(set) var results: [String: [ValidatorResult]] = [:]

  /// Failed validation results grouped by validation target.
  ///
  /// This dictionary contains only entries with at least one failure, using the same keys as
  /// `results`.
  public var failures: [String: [ValidatorResult.Failure]] {
    results.compactMapValues { results in
      let failures = results.compactMap { result -> ValidatorResult.Failure? in
        guard case .failure(let failure) = result else { return nil }
        return failure
      }

      return failures.isEmpty ? nil : failures
    }
  }

  /// Creates validations for the specified item.
  ///
  /// - Parameter item: The item to validate.
  public init(_ item: Item) {
    self.item = item
  }

  /// Applies validators to the value at the specified key path.
  ///
  /// Each validator is evaluated against the resolved value, and the resulting validation results
  /// are stored under the key path's final component.
  ///
  /// - Parameters:
  ///   - keyPath: The key path of the value to validate.
  ///   - validators: The validators to apply.
  public mutating func add<Value>(_ keyPath: KeyPath<Item, Value>, is validators: Validator<Value>...) {
    let value = item[keyPath: keyPath]
    let fieldName = String("\(keyPath)".split(separator: ".").last ?? "(unknown)")

    results[fieldName, default: []] += validators.map { $0.validate(value) }
  }

  /// Applies validators to the optional value at the specified key path.
  ///
  /// If the optional value is `nil`, validation is skipped and no result is recorded.
  ///
  /// - Parameters:
  ///   - keyPath: The key path of the optional value to validate.
  ///   - validators: The validators to apply when the value is present.
  public mutating func add<Value>(_ keyPath: KeyPath<Item, Value?>, is validators: Validator<Value>...) {
    guard let value = item[keyPath: keyPath] else { return }
    let fieldName = String("\(keyPath)".split(separator: ".").last ?? "(unknown)")

    results[fieldName, default: []] += validators.map { $0.validate(value) }
  }

  /// Applies an item-level validation predicate.
  ///
  /// Use this method for validations that depend on the whole item rather than a single property.
  /// The result is stored under the item type name.
  ///
  /// - Parameters:
  ///   - reason: The failure reason to record when `predicate` returns `false`.
  ///   - predicate: A closure that returns `true` when the item is valid.
  public mutating func add(_ reason: String, satisfies predicate: (Item) -> Bool) {
    let key = String(describing: Item.self)
    let result: ValidatorResult = predicate(item) ? .success : .failure(.init(reason: reason))

    results[key, default: []].append(result)
  }
}
