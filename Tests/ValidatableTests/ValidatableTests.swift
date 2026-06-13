import Testing

@testable import Validatable

@Suite("Validatable")
struct ValidatableTests {

  private struct User: Validatable {
    let name: String
    let roles: [String]

    static func validations(_ collector: inout Validations<User>) {
      collector.add(\.name, is: .nonEmpty)
      collector.add(\.roles, is: .nonEmpty)
    }
  }

  @Test("validate() does not throw when all fields are valid")
  func passesWhenValid() throws {
    let user = User(name: "Alice", roles: ["admin"])
    #expect(throws: Never.self) { try user.validate() }
  }

  @Test("validate() throws ValidationError when a field is invalid")
  func throwsWhenInvalid() {
    let user = User(name: "", roles: ["admin"])
    #expect(throws: ValidationError.self) { try user.validate() }
  }

  @Test("error.reasons contains the invalid field name")
  func errorContainsFieldName() throws {
    let user = User(name: "", roles: ["admin"])
    do {
      try user.validate()
      Issue.record("Expected validate() to throw")
    } catch let error as ValidationError {
      #expect(error.reasons["name"] != nil)
    }
  }

  @Test("error.reasons contains failure messages for the field")
  func errorContainsMessages() throws {
    let user = User(name: "", roles: ["admin"])
    do {
      try user.validate()
      Issue.record("Expected validate() to throw")
    } catch let error as ValidationError {
      let messages = error.reasons["name"] ?? []
      print()
      #expect(!messages.isEmpty)
    }
  }

  @Test("error.reasons contains entries for all invalid fields")
  func errorContainsAllInvalidFields() throws {
    let user = User(name: "", roles: [])
    do {
      try user.validate()
      Issue.record("Expected validate() to throw")
    } catch let error as ValidationError {
      #expect(error.reasons["name"] != nil)
      #expect(error.reasons["roles"] != nil)
    }
  }
}
