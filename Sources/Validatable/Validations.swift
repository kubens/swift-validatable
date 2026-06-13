/// Stores validation results for an item.
public struct Validations<Item> {

  private let item: Item

  /// Validation results grouped by key path.
  public private(set) var results: [String: [ValidatorResult]] = [:]

  /// Validation failures grouped by key path.
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
  /// - Parameters:
  ///   - keyPath: The key path of the value to validate.
  ///   - validators: The validators to apply.
  public mutating func add<Value>(_ keyPath: KeyPath<Item, Value>, is validators: Validator<Value>...) {
    let value = item[keyPath: keyPath]
    let fieldName = String("\(keyPath)".split(separator: ".").last ?? "(unknown)")

    results[fieldName, default: []] += validators.map { $0.validate(value) }
  }

  public mutating func add<Value>(_ keyPath: KeyPath<Item, Value?>, is validators: Validator<Value>...) {
    guard let value = item[keyPath: keyPath] else { return }
    let fieldName = String("\(keyPath)".split(separator: ".").last ?? "(unknown)")

    results[fieldName, default: []] += validators.map { $0.validate(value) }
  }
}
