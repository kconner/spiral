# spiral

## Problem

Write a command line program that will take a number, n, as an argument and print out the set of [1, n] in a spiral, with 1 in the center and the numbers increasing outward. Neither orientation nor direction are important.

Example:

```
$> spiral 14
10 11 12 13
 9  2  3 14
 8  1  4
 7  6  5
```

## Solution

This solution works on numbers as large as 170746489, but segfaults after that. The bottleneck is a memoizing hash of `[Location: Int]`; everything else more or less streams to stdout. And due to that memo, the only other bottleneck is printing.

