import Testing

@testable import Validatable

@Suite("Validations")
struct ValidationsTests {

  private struct Stub: Sendable {
    let name: String
    let tags: [String]
  }

  @Test("failures is empty when validators pass")
  func emptyWhenAllPass() {
    var validations = Validations(Stub(name: "Alice", tags: ["swift"]))
    validations.add(\.name, is: .nonEmpty)
    validations.add(\.tags, is: .nonEmpty)
    #expect(validations.failures.isEmpty)
  }

  @Test("failures contains entry when validator fails")
  func containsEntryWhenFails() {
    var validations = Validations(Stub(name: "", tags: ["swift"]))
    validations.add(\.name, is: .nonEmpty)
    #expect(!validations.failures.isEmpty)
  }

  @Test("failures key matches field name")
  func keyMatchesFieldName() {
    var validations = Validations(Stub(name: "", tags: []))
    validations.add(\.name, is: .nonEmpty)
    #expect(validations.failures["name"] != nil)
  }

  @Test("multiple validators on same field collect all failures")
  func multipleValidatorsOnSameField() {
    var validations = Validations(Stub(name: "", tags: []))
    validations.add(\.name, is: .nonEmpty, .min(3))
    let failures = validations.failures["name"] ?? []
    #expect(failures.count == 2)
  }

  @Test("failures for each field are independent")
  func independentFields() {
    var validations = Validations(Stub(name: "", tags: []))
    validations.add(\.name, is: .nonEmpty)
    validations.add(\.tags, is: .nonEmpty)
    #expect(validations.failures["name"] != nil)
    #expect(validations.failures["tags"] != nil)
  }

  @Test("passing field is absent from failures")
  func passingFieldAbsentFromFailures() {
    var validations = Validations(Stub(name: "Alice", tags: []))
    validations.add(\.name, is: .nonEmpty)
    validations.add(\.tags, is: .nonEmpty)
    #expect(validations.failures["name"] == nil)
    #expect(validations.failures["tags"] != nil)
  }
}

@Suite("Validations optional key path")
struct ValidationsOptionalTests {

  private struct Stub {
    let name: String?
  }

  @Test("nil optional field is skipped")
  func nilFieldIsSkipped() {
    var validations = Validations(Stub(name: nil))
    validations.add(\.name, is: .nonEmpty)
    #expect(validations.failures["name"] == nil)
  }

  @Test("non-nil optional field that passes has no failures")
  func nonNilPassingFieldHasNoFailures() {
    var validations = Validations(Stub(name: "Alice"))
    validations.add(\.name, is: .nonEmpty)
    #expect(validations.failures["name"] == nil)
  }

  @Test("non-nil optional field that fails produces failure")
  func nonNilFailingFieldProducesFailure() {
    var validations = Validations(Stub(name: ""))
    validations.add(\.name, is: .nonEmpty)
    #expect(validations.failures["name"] != nil)
  }

  @Test("nil field does not affect other fields")
  func nilFieldDoesNotAffectOtherFields() {
    struct MultiStub {
      let name: String?
      let role: String
    }
    var validations = Validations(MultiStub(name: nil, role: ""))
    validations.add(\.name, is: .nonEmpty)
    validations.add(\.role, is: .nonEmpty)

    #expect(validations.failures["name"] == nil)
    #expect(validations.failures["role"] != nil)
  }
}

@Suite("Validations item predicate")
struct ValidationsItemPredicateTests {

  private struct Stub: Sendable {
    let start: Int
    let end: Int
  }

  @Test("passing predicate has no failures")
  func passingPredicateHasNoFailures() {
    var validations = Validations(Stub(start: 1, end: 2))
    validations.add("start must be before end") { item in
      item.start < item.end
    }

    #expect(validations.failures.isEmpty)
  }

  @Test("failing predicate records reason")
  func failingPredicateRecordsReason() {
    var validations = Validations(Stub(start: 2, end: 1))
    validations.add("start must be before end") { item in
      item.start < item.end
    }

    let reasons = validations.failures.values.flatMap { failures in
      failures.map(\.reason)
    }

    #expect(reasons == ["start must be before end"])
  }

  @Test("multiple predicates are appended to the same item validation")
  func multiplePredicatesAreAppendedToSameItemValidation() {
    var validations = Validations(Stub(start: 2, end: 1))
    let key = String(describing: Stub.self)

    validations.add("start must be before end") { item in
      item.start < item.end
    }
    validations.add("range must be non-empty") { item in
      item.start != item.end
    }

    #expect(validations.results[key]?.count == 2)
    #expect(validations.failures[key]?.map(\.reason) == ["start must be before end"])
  }
}
