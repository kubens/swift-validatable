/// Validators for string formats.
///
/// These validators use Swift regular expressions and match the entire string. For length and
/// emptiness checks on strings, use the collection validators such as `.nonEmpty`, `.min(_:)`,
/// `.max(_:)`, and `.count(_:)`.
///
/// ```swift
/// struct Contact: Validatable {
///   let email: String
///   let phone: String
///
///   static func validations(_ collector: inout Validations<Self>) {
///     collector.add(\.email, is: .nonEmpty, .email)
///     collector.add(\.phone, is: .e164)
///   }
/// }
/// ```
extension Validator where Value == String {

  /// Validates that a string is a valid E.164 phone number.
  ///
  /// E.164 numbers start with `+`, followed by a non-zero country code and 8 to 14 additional
  /// digits.
  ///
  /// ```swift
  /// collector.add(\.phoneNumber, is: .e164)
  /// ```
  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  public static var e164: Self {
    Validator("must be a valid E.164 phone number") { value in
      value.wholeMatch(of: /\+[1-9]\d{8,14}/) != nil
    }
  }

  /// Validates that a string is a valid email address.
  ///
  /// The validator matches common email address forms and requires the entire string to match.
  ///
  /// ```swift
  /// collector.add(\.email, is: .nonEmpty, .email)
  /// ```
  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  public static var email: Self {
    Validator("must be a valid email address") { value in
      value.wholeMatch(of: /(?i)(?!\.)(?!.*\.\.)[a-z0-9_'+\-.]*[a-z0-9_+\-]@([a-z0-9][a-z0-9\-]*\.)+[a-z]{2,}/) != nil
    }
  }

  /// Validates that a string matches the specified regular expression.
  ///
  /// The regular expression must match the whole string, not just a substring.
  ///
  /// ```swift
  /// collector.add(\.postalCode, is: .pattern(/\d{2}-\d{3}/))
  /// ```
  ///
  /// - Parameter regex: The regular expression to match against.
  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  public static func pattern(_ regex: some RegexComponent) -> Self {
    Validator("must match \(regex) pattern") { value in
      value.wholeMatch(of: regex) != nil
    }
  }
}
