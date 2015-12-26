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

#Contribution

You are welcome to fork and submit pull requests.

#License

Progress.swift is released under the MIT license. See [LICENSE](https://github.com/jkandzi/Progress.swift/blob/master/LICENSE.txt) for details.
