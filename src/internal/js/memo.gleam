@target(javascript)
import gleam/dict.{type Dict}
@target(javascript)
import javascript/mutable_reference.{type MutableReference}

@target(javascript)
pub type Cache(k, v) =
  MutableReference(Dict(k, v))

@target(javascript)
/// Create a memoization cache.  Pass this cache to the function you want to memoize.
/// 
/// This is best used with a `use` expression:
/// ```gleam
/// use cache <- create()
/// f(a, b, c, cache)
/// ```
/// 
pub fn create(apply fun: fn(Cache(a, b)) -> c) -> c {
  dict.new() |> mutable_reference.new |> fun
}

@target(javascript)
/// Manually add a key-value pair to the memoization cache.
pub fn set(in cache: Cache(k, v), for key: k, insert value: v) -> Nil {
  mutable_reference.update(cache, fn(d) { dict.insert(d, key, value) })
  Nil
}

@target(javascript)
/// Manually look up a value from the memoization cache for a given key.
pub fn get(from cache: Cache(k, v), fetch key: k) -> Result(v, Nil) {
  cache |> mutable_reference.get |> dict.get(key)
}

@target(javascript)
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
pub fn memoize(with cache: Cache(k, v), this key: k, apply fun: fn() -> v) -> v {
  case get(from: cache, fetch: key) {
    Ok(value) -> value
    Error(Nil) -> {
      let result = fun()
      set(cache, key, result)
      result
    }
  }
}
