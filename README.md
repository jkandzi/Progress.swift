# Progress.swift :hourglass:
[![Build Status](https://travis-ci.org/jkandzi/Progress.swift.svg?branch=master)](https://travis-ci.org/jkandzi/Progress.swift)
[![codecov.io](https://codecov.io/github/jkandzi/Progress.swift/coverage.svg?branch=master)](https://codecov.io/github/jkandzi/Progress.swift?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM ready](https://img.shields.io/badge/SPM-ready-orange.svg)](https://www.swift.org)
[![Version](https://img.shields.io/cocoapods/v/Progress.swift.svg?style=flat)](http://cocoapods.org/pods/Progress.swift)
[![License](https://img.shields.io/cocoapods/l/Progress.swift.svg?style=flat)](http://cocoapods.org/pods/Progress.swift)
[![Platform](https://img.shields.io/cocoapods/p/Progress.swift.svg?style=flat)](http://cocoapods.org/pods/Progress.swift)

![demo gif](https://github.com/jkandzi/Progress.swift/blob/master/demo.gif)

Just wrap the `SequenceType` in your loop with the `Progress SequenceType` and you'll automatically get beautiful progress bars.

Updating the progress bar does not work in the Xcode console because it does not support the cursor movements. If you want it to look nice run it in a real terminal.

## Example

Just take a regular loop like this `for i in 1...9 { ...` and wrap the `1...9` range in the `Progress` type and you'll automatically get a nice progress bar.

```swift
import Progress

for i in Progress(1...9) {
    ...
}
```

Creates this output:

```
$ 4 of 9 [-------------                 ] ETA: 0:00:05 (at 1.01 it/s)
```

It also works with all the other types adopting the `CollectionType` protocol like dictionarys: `Progress(["key": "value", "key2": "also value"])` and arrays: `Progress([1, 52, 6, 26, 1])`.

You can also create the progress bar manually without a sequence type:

```swift
var bar = ProgressBar(count: 4)

for i in 0...3 {
    bar.next()
    sleep(1)
}
```

### Configuration

You can configure the progress bar by combining single building blocks of type `ProgressElementType`.

Either by setting a default configuration:

```swift
ProgressBar.defaultConfiguration = [ProgressString(string: "Percent done:"), ProgressPercent()]
```

which creates the following result:

```
$ Percent done: 80%
```

or by providing a specific configuration in the Process initializer:

```swift
Progress(0...10, configuration: [ProgressPercent(), ProgressBarLine(barLength: 60)])
```

resulting in something like this:

```
$ 100% [------------------------------------------------------------]
```

**Available `ProgressElementType` elements:**

* `ProgressBarLine` (The actual bar. E.g. "[----------------------        ]").
* `ProgressIndex` (The current index & overall count. E.g. "2 of 3").
* `ProgressPercent` (The progress in percent. E.g. "60%").
* `ProgressTimeEstimates` (Estimated time remaining & items per second. E.g. "ETA: 00:00:02 (at 1.00 it/s)").
* `ProgressString` (Adds an arbitrary string to the progress bar).

## Installation

### Cocoapods

Progress.swift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Progress.swift"
```

### Carthage

To integrate Progress.swift into your Xcode project using Carthage, specify it in your Cartfile:

```
github "jkandzi/Progress.swift"
```

Run `carthage update` to build the framework and drag the built `Progress.framework` into your Xcode project.

### Swift Package Manager

To install with the Swift Package Manager, add the following in your `Package.swift`:

```swift
import PackageDescription

let package = Package(
    name: "MyProject",
    dependencies: [
        .Package(url: "https://github.com/jkandzi/Progress.swift", majorVersion: 0)
    ]
)
```

### Manual

You can also copy the `Progress.swift` file into your Xcode project.

## Contribution

You are welcome to fork and submit pull requests.

## Author

Justus Kandzi, justus.kandzi@gmail.com

## License

Progress.swift is available under the MIT license. See the [LICENSE](https://github.com/jkandzi/Progress.swift/blob/master/LICENSE.txt) file for more info.
