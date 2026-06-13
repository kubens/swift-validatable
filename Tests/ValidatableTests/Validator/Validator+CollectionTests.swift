import Testing

@testable import Validatable

@Suite("Validator<Collection>")
struct ValidatorCollectionTests {

  // MARK: - notEmpty

  @Suite(".notEmpty")
  struct NotEmptyTests {

    @Test("passes for non-empty array")
    func passesForNonEmptyArray() {
      let result = Validator<[Int]>.nonEmpty.validate([1, 2, 3])
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails for empty array")
    func failsForEmptyArray() {
      let result = Validator<[Int]>.nonEmpty.validate([])
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("passes for non-empty string")
    func passesForNonEmptyString() {
      let result = Validator<String>.nonEmpty.validate("hello")
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails for empty string")
    func failsForEmptyString() {
      let result = Validator<String>.nonEmpty.validate("")
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("failure contains expected reason")
    func failureReason() {
      let result = Validator<String>.nonEmpty.validate("")
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "value cannot be empty")
    }
  }

  // MARK: - min

  @Suite(".min")
  struct MinTests {

    @Test("passes when count equals min")
    func passesAtExactMin() {
      let result = Validator<[Int]>.min(3).validate([1, 2, 3])
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("passes when count exceeds min")
    func passesAboveMin() {
      let result = Validator<[Int]>.min(3).validate([1, 2, 3, 4])
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails when count is below min")
    func failsBelowMin() {
      let result = Validator<[Int]>.min(3).validate([1, 2])
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("failure contains expected reason")
    func failureReason() {
      let result = Validator<[Int]>.min(3).validate([1])
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "count must be at least 3")
    }
  }

  // MARK: - max

  @Suite(".max")
  struct MaxTests {

    @Test("passes when count equals max")
    func passesAtExactMax() {
      let result = Validator<[Int]>.max(3).validate([1, 2, 3])
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("passes when count is below max")
    func passesBelowMax() {
      let result = Validator<[Int]>.max(3).validate([1, 2])
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails when count exceeds max")
    func failsAboveMax() {
      let result = Validator<[Int]>.max(3).validate([1, 2, 3, 4])
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("failure contains expected reason")
    func failureReason() {
      let result = Validator<[Int]>.max(2).validate([1, 2, 3])
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "count must be at most 2")
    }
  }

  // MARK: - count

  @Suite(".count")
  struct CountTests {

    @Test("passes when count matches exactly")
    func passesAtExactCount() {
      let result = Validator<[Int]>.count(3).validate([1, 2, 3])
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails when count is less than expected")
    func failsWhenTooFew() {
      let result = Validator<[Int]>.count(3).validate([1, 2])
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("fails when count is greater than expected")
    func failsWhenTooMany() {
      let result = Validator<[Int]>.count(3).validate([1, 2, 3, 4])
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("failure contains expected reason")
    func failureReason() {
      let result = Validator<[Int]>.count(3).validate([1, 2])
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "count must be exactly 3")
    }
  }
}
