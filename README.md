# rememo

[![Package Version](https://img.shields.io/hexpm/v/rememo)](https://hex.pm/packages/rememo)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/rememo/)

This is a basic memoization method for Gleam on the Erlang target, using an actor to cache and reuse the results of function calls when possible.  

There is some overhead to sending messages and caching the dictionary of results, but in situations that call for it, like dynamic programming problems where the same basic subproblem recurs hundreds or thousands of times, the tradeoff is worthwhile.  Always benchmark your code when in doubt.

```sh
gleam add rememo
```
```gleam
import memo/ets/memo // This is the recommended implementation to use
import gleam/io

pub fn main() {
  // Start the actor that holds the cached values
  // for the duration of this block
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