//// The memoization implementation depends on the build target.
//// 
//// * For the Erlang build target, the cache is a Erlang Term Storage database.
//// * For the Javascript build target, the cache is a mutable Javascript map.

@target(erlang)
import internal/ets/memo as ets

@target(javascript)
import internal/js/memo as js

@target(erlang)
/// Start an actor that holds a memoization cache.  Pass this cache to the
/// function you want to memoize.
/// This is best used with a `use` expression:
/// ```gleam
/// use cache <- create()
/// f(a, b, c, cache)
/// ```
/// 
pub fn create(apply fun) {
  ets.create(fun)
}

@target(javascript)
pub fn create(apply fun) {
  js.create(fun)
}

@target(erlang)
/// Manually add a key-value pair to the memoization cache.
pub fn set(in cache, for key, insert value) {
  ets.set(cache, key, value)
}

@target(javascript)
pub fn set(in cache, for key, insert value) {
  js.set(cache, key, value)
}

@target(erlang)
/// Manually look up a value from the memoization cache for a given key.
pub fn get(from cache, fetch key) {
  ets.get(cache, key)
}

@target(javascript)
pub fn get(from cache, fetch key) {
  js.get(cache, key)
}

@target(erlang)
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
pub fn memoize(with cache, this key, apply fun) {
  ets.memoize(cache, key, fun)
}

@target(javascript)
pub fn memoize(with cache, this key, apply fun) {
  js.memoize(cache, key, fun)
}
