extension Validator where Value == String {

  /// Validates that a string is a valid E.164 phone number.
  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  public static var e164: Self {
    Validator("must be a valid E.164 phone number") { value in
      value.wholeMatch(of: /\+[1-9]\d{8,14}/) != nil
    }
  }

  /// Validates that a string is a valid email address.
  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  public static var email: Self {
    Validator("must be a valid email address") { value in
      value.wholeMatch(of: /(?i)(?!\.)(?!.*\.\.)[a-z0-9_'+\-.]*[a-z0-9_+\-]@([a-z0-9][a-z0-9\-]*\.)+[a-z]{2,}/) != nil
    }
  }

  /// Validates that a string matches the specified regular expression.
  ///
  /// - Parameter regex: The regular expression to match against.
  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  public static func pattern(_ regex: some RegexComponent) -> Self {
    Validator("must match \(regex) pattern") { value in
      value.wholeMatch(of: regex) != nil
    }
  }
}
