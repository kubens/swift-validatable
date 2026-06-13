import Testing

@testable import Validatable

@Suite("Validator<Numeric>")
struct ValidatorNumericTests {

  // MARK: - positive

  @Suite(".positive")
  struct PositiveTests {

    @Test("passes for positive integer")
    func passesForPositiveInt() {
      let result = Validator<Int>.positive.validate(1)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails for zero")
    func failsForZero() {
      let result = Validator<Int>.positive.validate(0)
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("fails for negative integer")
    func failsForNegativeInt() {
      let result = Validator<Int>.positive.validate(-1)
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("failure contains expected reason")
    func failureReason() {
      let result = Validator<Int>.positive.validate(0)
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "must be positive")
    }
  }

  // MARK: - negative

  @Suite(".negative")
  struct NegativeTests {

    @Test("passes for negative integer")
    func passesForNegativeInt() {
      let result = Validator<Int>.negative.validate(-1)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails for zero")
    func failsForZero() {
      let result = Validator<Int>.negative.validate(0)
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("fails for positive integer")
    func failsForPositiveInt() {
      let result = Validator<Int>.negative.validate(1)
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }
  }

  // MARK: - nonNegative

  @Suite(".nonNegative")
  struct NonNegativeTests {

    @Test("passes for positive integer")
    func passesForPositiveInt() {
      let result = Validator<Int>.nonNegative.validate(1)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("passes for zero")
    func passesForZero() {
      let result = Validator<Int>.nonNegative.validate(0)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails for negative integer")
    func failsForNegativeInt() {
      let result = Validator<Int>.nonNegative.validate(-1)
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }
  }

  // MARK: - nonPositive

  @Suite(".nonPositive")
  struct NonPositiveTests {

    @Test("passes for negative integer")
    func passesForNegativeInt() {
      let result = Validator<Int>.nonPositive.validate(-1)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("passes for zero")
    func passesForZero() {
      let result = Validator<Int>.nonPositive.validate(0)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails for positive integer")
    func failsForPositiveInt() {
      let result = Validator<Int>.nonPositive.validate(1)
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }
  }

  // MARK: - min

  @Suite(".min")
  struct MinTests {

    @Test("passes when value equals min")
    func passesAtExactMin() {
      let result = Validator<Int>.min(5).validate(5)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("passes when value exceeds min")
    func passesAboveMin() {
      let result = Validator<Int>.min(5).validate(10)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails when value is below min")
    func failsBelowMin() {
      let result = Validator<Int>.min(5).validate(4)
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("failure contains expected reason")
    func failureReason() {
      let result = Validator<Int>.min(5).validate(4)
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "must be at least 5")
    }
  }

  // MARK: - max

  @Suite(".max")
  struct MaxTests {

    @Test("passes when value equals max")
    func passesAtExactMax() {
      let result = Validator<Int>.max(5).validate(5)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("passes when value is below max")
    func passesBelowMax() {
      let result = Validator<Int>.max(5).validate(3)
      guard case .success = result else {
        Issue.record("Expected success")
        return
      }
    }

    @Test("fails when value exceeds max")
    func failsAboveMax() {
      let result = Validator<Int>.max(5).validate(6)
      guard case .failure = result else {
        Issue.record("Expected failure")
        return
      }
    }

    @Test("failure contains expected reason")
    func failureReason() {
      let result = Validator<Int>.max(5).validate(6)
      guard case .failure(let failure) = result else {
        Issue.record("Expected failure")
        return
      }
      #expect(failure.reason == "must be at most 5")
    }
  }
}
