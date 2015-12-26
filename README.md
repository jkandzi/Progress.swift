# Progress.swift

Just wrap the `SequenceType` in your loop with the `Progress SequenceType` and you'll automatically get beautiful progress bars.

```
for i in 1...9 {
	...
}
```


```
for i in Progress(1...9) {
    ...
}
```


```
4 of 9 [-------------                 ] ETA: 0:00:05 (at 1.01 it/s)
```