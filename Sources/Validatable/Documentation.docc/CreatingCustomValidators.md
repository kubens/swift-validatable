# Creating Custom Validators

Create custom validators when built-in validators do not cover a domain-specific rule.

## Overview

A ``Validator`` validates one value and returns a ``ValidatorResult``. For simple pass-or-fail rules, create a validator with ``Validator/init(_:satisfies:)``.

```swift
let even = Validator<Int>("must be even") { $0.isMultiple(of: 2) }
let result = even.validate(3)
```

Use ``Validator/init(validate:)`` when the validator needs to return a complete result itself.

```swift
let maximum = Validator<Int> { value in
  value <= 10 ? .success : .failure(.init(reason: "must be at most 10"))
}
```

## Reusing Validators

Define reusable validators in an extension constrained to the value type they validate. This makes the validator available with dot syntax in `collector.add(_:is:)`.

```swift
extension Validator where Value == Int {
  static var even: Self {
    Validator("must be even") { $0.isMultiple(of: 2) }
  }
}
```

Use the custom validator alongside built-in validators in a ``Validatable`` type.

```swift
struct Ticket: Validatable {
  let seats: Int

  static func validations(_ collector: inout Validations<Self>) {
    collector.add(\.seats, is: .positive, .even)
  }
}
```

## Cross-Property Validation

When a rule depends on multiple properties, add a cross-property predicate instead of creating a property validator. See <doc:CrossPropertyValidation>.

## Topics

### Creating Validators

- ``Validator/init(_:satisfies:)``
- ``Validator/init(validate:)``
- ``Validator/validate``

### Reporting Results

- ``ValidatorResult``
- ``ValidatorResult/success``
- ``ValidatorResult/failure(_:)``
