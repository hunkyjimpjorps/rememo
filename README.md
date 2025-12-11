# rememo

[![Package Version](https://img.shields.io/hexpm/v/rememo)](https://hex.pm/packages/rememo)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/rememo/)

This is a basic [memoization](https://en.wikipedia.org/wiki/Memoization) method for Gleam on both the Erlang and Javascript targets, for caching and reusing the results of function calls when possible.  

Adding to and reading from the memoization cache incurs some overhead, but in situations that call for it, like dynamic programming problems where the same basic subproblem recurs hundreds or thousands of times, the tradeoff is worthwhile.  Always benchmark your code when in doubt.

```sh
gleam add rememo
```

```gleam
import rememo/memo 
import gleam/io

pub fn main() {
  // Make the mutable state that holds the cached values
  // for the duration of this block, return the final value of 
  // the called function, then delete the mutable state
  use cache <- memo.create()
  fib(300, cache)
  |> io.debug
}

fn fib(n, cache) {
  // Check if a value exists for the key n
  // Use it if it exists, update the cache if it doesn't
  use <- memo.memoize(cache, n)
  case n {
    1 | 2 -> 1
    n -> fib(n - 1, cache) + fib(n - 2, cache)
  }
}
```

Further documentation can be found at <https://hexdocs.pm/rememo>.

## Contributing and development

Suggestions and pull requests are welcome.
