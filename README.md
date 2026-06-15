# swift-validatable

`swift-validatable` is a small Swift package for defining validation rules on model types and collecting readable validation failures.

## Overview

Conform a type to `Validatable`, add rules in `validations(_:)`, and call `validate()` on an instance.

```swift
import Validatable

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

## Installation

Add the package to a Swift Package Manager project:

```swift
.package(url: "https://github.com/kubens/swift-validatable.git", from: "0.1.0")
```

Then add `Validatable` to your target dependencies.

## Documentation

The detailed documentation lives in DocC:

- [Using Built-In Validators](Sources/Validatable/Documentation.docc/UsingBuiltInValidators.md)
- [Creating Custom Validators](Sources/Validatable/Documentation.docc/CreatingCustomValidators.md)
- [API Overview](Sources/Validatable/Documentation.docc/Documentation.md)

## License

See the package repository for license information.
