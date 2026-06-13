/// An error containing all validation failures grouped by field.
public struct ValidationError: Error {

  /// Validation failure reasons grouped by field name.
  public let reasons: [String: [String]]
}
