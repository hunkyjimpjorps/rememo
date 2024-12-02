import gleeunit
import gleeunit/should
import rememo/memo

pub fn main() {
  gleeunit.main()
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

// gleeunit test functions end in `_test`
pub fn fibonacci_test() {
  {
    use cache <- memo.create()
    fib(50, cache)
  }
  |> should.equal(12_586_269_025)
}
