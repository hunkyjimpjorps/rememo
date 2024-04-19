//// This is the memoization implementation that uses [Erlang Term Storage](https://www.erlang.org/doc/man/ets.html) (ETS).  
//// This is the faster (and newer) of the two implementations.

import carpenter/table.{type Set, AutoWriteConcurrency, Private}
import youid/uuid

/// Start an actor that holds a memoization cache.  Pass this cache to the
/// function you want to memoize.
/// This is best used with a `use` expression:
/// ```gleam
/// use cache <- create()
/// f(a, b, c, cache)
/// ```
/// 
pub fn create(apply fun: fn(Set(k, v)) -> t) {
  let table_name = uuid.v4_string()

  let assert Ok(cache_table) =
    table.build(table_name)
    |> table.privacy(Private)
    |> table.write_concurrency(AutoWriteConcurrency)
    |> table.read_concurrency(True)
    |> table.decentralized_counters(True)
    |> table.compression(False)
    |> table.set()

  let result = fun(cache_table)
  table.drop(cache_table)
  result
}

/// Manually add a key-value pair to the memoization cache.
pub fn set(in cache: Set(k, v), for key: k, insert value: v) -> Nil {
  table.insert(cache, [#(key, value)])
}

/// Manually look up a value from the memoization cache for a given key.
pub fn get(from cache: Set(k, v), fetch key: k) -> Result(v, Nil) {
  case table.lookup(cache, key) {
    [] -> Error(Nil)
    [#(_, v), ..] -> Ok(v)
  }
}

/// Look up the value associated with the given key in the memoization cache,
/// and return it if it exists.  If it doesn't exist, evaluate the callback function
/// and update the cache with the value it returns.
/// 
/// This works well with a `use` expression:
/// ```gleam
/// fn f(a, b, c, cache) {
///   use <- memoize(cache, #(a, b, c))
///   // function body goes here
/// }
/// ```
/// 
pub fn memoize(with cache: Set(k, v), this key: k, apply fun: fn() -> v) -> v {
  case get(from: cache, fetch: key) {
    Ok(value) -> value
    Error(Nil) -> {
      let result = fun()
      set(in: cache, for: key, insert: result)
      result
    }
  }
}
