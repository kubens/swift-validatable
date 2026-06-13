import Testing

@testable import Validatable

@Suite("Validator<String>")
struct ValidatorStringTests {

  // MARK: - email

  @Suite(".email")
  struct EmailTests {

    @Test(
      "passes for valid email",
      arguments: [
        "user@example.com",
        "user.name+tag@domain.co.uk",
        "user_name@sub.domain.com",
      ])
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func passesForValidEmail(email: String) {
      let result = Validator<String>.email.validate(email)
      guard case .success = result else {
        Issue.record("Expected success for \(email)")
        return
      }
    }

    @Test(
      "fails for invalid email",
      arguments: [
        "",
        "notanemail",
        "@domain.com",
        "user@",
        "user..name@domain.com",
        ".user@domain.com",
      ])
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func failsForInvalidEmail(email: String) {
      let result = Validator<String>.email.validate(email)
      guard case .failure = result else {
        Issue.record("Expected failure for \(email)")
        return
      }
    }

    @Test("failure contains expected reason")
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func failureReason() {
      let result = Validator<String>.email.validate("notanemail")
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "must be a valid email address")
    }
  }

  // MARK: - e164

  @Suite(".e164")
  struct E164Tests {

    @Test(
      "passes for valid E.164 number",
      arguments: [
        "+48123456789",
        "+12125551234",
        "+447911123456",
      ])
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func passesForValidNumber(phone: String) {
      let result = Validator<String>.e164.validate(phone)
      guard case .success = result else {
        Issue.record("Expected success for \(phone)")
        return
      }
    }

    @Test(
      "fails for invalid E.164 number",
      arguments: [
        "",
        "48123456789",
        "+0123456789",
        "+1",
        "123",
      ])
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func failsForInvalidNumber(phone: String) {
      let result = Validator<String>.e164.validate(phone)
      guard case .failure = result else {
        Issue.record("Expected failure for \(phone)")
        return
      }
    }

    @Test("failure contains expected reason")
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func failureReason() {
      let result = Validator<String>.e164.validate("123")
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "must be a valid E.164 phone number")
    }
  }
}
