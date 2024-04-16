import gleam/dict.{type Dict}
import gleam/otp/actor.{type Next, Continue, Stop}
import gleam/erlang/process.{type Subject, Normal}
import gleam/option.{None}

const timeout = 1000

type Message(k, v) {
  Shutdown
  Get(key: k, client: Subject(Result(v, Nil)))
  Set(key: k, value: v)
}

type Server(k, v) =
  Subject(Message(k, v))

pub opaque type Cache(k, v) {
  Cache(server: Server(k, v))
}

fn handle_message(
  message: Message(k, v),
  dict: Dict(k, v),
) -> Next(Message(k, v), Dict(k, v)) {
  case message {
    Shutdown -> Stop(Normal)
    Get(key, client) -> {
      process.send(client, dict.get(dict, key))
      Continue(dict, None)
    }
    Set(key, value) -> Continue(dict.insert(dict, key, value), None)
  }
}

/// Start an actor that holds a memoization cache.  Pass this cache to the
/// function you want to memoize.
/// This is best used with a `use` expression:
/// ```gleam
/// use cache <- create()
/// f(a, b, c, cache)
/// ```
/// 
pub fn create(apply fun: fn(Cache(k, v)) -> t) -> t {
  let assert Ok(server) = actor.start(dict.new(), handle_message)
  let result = fun(Cache(server))
  process.send(server, Shutdown)
  result
}

/// Manually add a key-value pair to the memoization cache.
pub fn set(in cache: Cache(k, v), for key: k, insert value: v) -> Nil {
  process.send(cache.server, Set(key, value))
}

/// Manually look up a value from the memoization cache for a given key.
pub fn get(from cache: Cache(k, v), fetch key: k) -> Result(v, Nil) {
  process.call(cache.server, fn(c) { Get(key, c) }, timeout)
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
pub fn memoize(with cache: Cache(k, v), this key: k, apply fun: fn() -> v) -> v {
  let result = case get(from: cache, fetch: key) {
    Ok(value) -> value
    Error(Nil) -> fun()
  }
  set(in: cache, for: key, insert: result)
  result
}
