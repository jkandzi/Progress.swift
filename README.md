# Progress.swift

Just wrap the `SequenceType` in your loop with the `Progress SequenceType` and you'll automatically get beautiful progress bars.

# Example

```swift
for i in 1...9 {
	...
}
```


```swift
for i in Progress(1...9) {
    ...
}
```


```
$ 4 of 9 [-------------                 ] ETA: 0:00:05 (at 1.01 it/s)
```

#Installation
##Swift Package Manager

To install with the Swift Package Manager, add the following in your `Package.swift`:

```swift
import PackageDescription

let package = Package(
    name: "My Project",
    dependencies: [
        .Package(url: "https://github.com/jkandzi/Progress.swift", majorVersion: 0)]),
    ]
)
```

##Manual

You can also copy the `Progress.swift` file into your Xcode project.

#Contribution

You are welcome to fork and submit pull requests.

#License

Progress.swift is released under the MIT license. See [https://github.com/jkandzi/Progress.swift/blob/master/LICENSE.txt](LICENSE) for details.
