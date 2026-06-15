# ``Validatable``

Define validation rules for Swift types and collect readable validation failures.

## Overview

Conform a type to ``Validatable`` by implementing ``Validatable/validations(_:)``. The validation collector receives property-level validators and item-level predicates.

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
  
  try RangeInput(start: 0, end: 10).validate()
```

## Topics

### Essentials

- <doc:UsingBuiltInValidators>
- <doc:CreatingCustomValidators>
- <doc:CrossPropertyValidation>

### Core Types

- ``Validatable``
- ``Validations``
- ``Validator``
- ``ValidatorResult``
- ``ValidationError``
