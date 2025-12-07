//// The memoization implementation depends on the build target.
//// 
//// * For the Erlang build target, the cache is a [Erlang Term Storage 
//// database](https://www.erlang.org/doc/apps/erts/persistent_term.html).
//// * For the Javascript build target, the cache is a [mutable Javascript map](
//// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map).
import internal/ets/memo as ets

/// Make a new memoization cache, of the appropriate type for the build target.
/// Pass this cache to the function you want to memoize.
/// 
/// This is best used with a `use` expression:
/// ```gleam
/// use cache <- create()
/// f(a, b, c, cache)
/// ```
/// 
pub fn create(apply fun) {
  ets.create(fun)
}

/// Manually add a key-value pair to the memoization cache.
/// Useful if you need to pre-seed the cache with a starting value, for example.
pub fn set(in cache, for key, insert value) {
  ets.set(cache, key, value)
}

/// Manually look up a value from the memoization cache for a given key.
/// Useful if you want to also return intermediate results as well as a final result, for example.
pub fn get(from cache, fetch key) {
  ets.get(cache, key)
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
pub fn memoize(with cache, this key, apply fun) {
  ets.memoize(cache, key, fun)
}
