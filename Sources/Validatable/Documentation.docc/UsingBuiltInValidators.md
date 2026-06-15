# Using Built-In Validators

Use built-in validators to describe common validation rules without writing custom validation logic.

## Overview

Built-in validators are exposed as static members on ``Validator``. Add them to a ``Validations`` collector inside ``Validatable/validations(_:)``.

```swift
struct Profile: Validatable {
  let username: String
  let age: Int
  let tags: [String]

  static func validations(_ collector: inout Validations<Self>) {
    collector.add(\.username, is: .nonEmpty, .min(3), .max(20))
    collector.add(\.age, is: .min(18))
    collector.add(\.tags, is: .max(5))
  }
}
```

## Collection Validators

Collection validators work with any `Collection`, including `String`, `Array`, `Set`, and `Dictionary`. They validate either `isEmpty` or `count`.

```swift
struct Form: Validatable {
  let title: String
  let selectedOptions: [String]

  static func validations(_ collector: inout Validations<Self>) {
    collector.add(\.title, is: .nonEmpty, .max(80))
    collector.add(\.selectedOptions, is: .min(1), .max(3))
  }
}
```

Use these validators for collection values:

- ``Validator/nonEmpty``
- `Validator.min(_:)` for a minimum collection count
- `Validator.max(_:)` for a maximum collection count
- ``Validator/count(_:)``

## Numeric Validators

Numeric validators work with values that conform to both `Comparable` and `AdditiveArithmetic`, such as `Int`, `Double`, and `Decimal`.

```swift
struct Product: Validatable {
  let price: Decimal
  let stock: Int

  static func validations(_ collector: inout Validations<Self>) {
    collector.add(\.price, is: .positive)
    collector.add(\.stock, is: .nonNegative, .max(100))
  }
}
```

Use these validators for numeric-like values:

- ``Validator/positive``
- ``Validator/negative``
- ``Validator/nonNegative``
- ``Validator/nonPositive``
- `Validator.min(_:)` for a minimum numeric value
- `Validator.max(_:)` for a maximum numeric value

## String Format Validators

String format validators match the whole string. Use collection validators such as ``Validator/nonEmpty``, `Validator.min(_:)`, and `Validator.max(_:)` for string length rules.

```swift
struct Contact: Validatable {
  let email: String
  let phone: String
  let postalCode: String

  static func validations(_ collector: inout Validations<Self>) {
    collector.add(\.email, is: .nonEmpty, .email)
    collector.add(\.phone, is: .e164)
    collector.add(\.postalCode, is: .pattern(/\d{2}-\d{3}/))
  }
}
```

Use these validators for string formats:

- ``Validator/email``
- ``Validator/e164``
- ``Validator/pattern(_:)``
