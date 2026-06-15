# Cross-Property Validation

Use cross-property validation when a rule depends on multiple properties instead of one field in isolation.

## Overview

Property validators work well when a rule can validate one field on its own. When a rule compares multiple properties, add a predicate directly to the ``Validations`` collector with ``Validations/add(_:satisfies:)``.

```swift
struct RangeInput: Validatable {
  let start: Int
  let end: Int

  static func validations(_ collector: inout Validations<Self>) {
    collector.add(\.start, is: .min(0))
    collector.add(\.end, is: .min(0))
    collector.add("start must be before end") { $0.start < $0.end }
  }
}
```

The predicate receives the whole validated value. Return `true` when the relationship between properties is valid and `false` when validation should fail.

## When to Use Cross-Property Validation

Use cross-property validation for rules that need more context than a single property can provide.

```swift
struct Booking: Validatable {
  let startDate: Date
  let endDate: Date
  let guestCount: Int
  let roomCapacity: Int

  static func validations(_ collector: inout Validations<Self>) {
    collector.add(\.guestCount, is: .positive)
    collector.add(\.roomCapacity, is: .positive)
    collector.add("end date must be after start date") { $0.startDate < $0.endDate }
    collector.add("guest count must not exceed room capacity") { $0.guestCount <= $0.roomCapacity }
  }
}
```

Use property-level validators first for independent field rules, then add cross-property predicates for relationships between fields.

## Failure Grouping

When a cross-property predicate fails, the failure is grouped under the validated type's name in ``ValidationError/reasons``.

```swift
let input = RangeInput(start: 10, end: 5)

do {
  try input.validate()
} catch let error as ValidationError {
  print(error.reasons["RangeInput"])
}
```

This keeps property failures and whole-value failures separate: property validators are grouped by property name, while item-level predicates are grouped by type name.

## Topics

### Item-Level Rules

- ``Validations/add(_:satisfies:)``
- ``Validations``
- ``ValidationError``
