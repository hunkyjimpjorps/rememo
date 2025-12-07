@target(erlang)
import gleam/string
@target(erlang)
import internal/carpenter/table.{type Set, AutoWriteConcurrency, Private}
@target(erlang)
import tempo/instant

@target(erlang)
pub type Cache(k, v) =
  Set(k, v)

@target(erlang)
pub fn create(apply fun: fn(Cache(k, v)) -> t) {
  let table_name = instant.now() |> string.inspect

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

@target(erlang)
pub fn set(in cache: Cache(k, v), for key: k, insert value: v) -> Nil {
  table.insert(cache, [#(key, value)])
}

@target(erlang)
pub fn get(from cache: Cache(k, v), fetch key: k) -> Result(v, Nil) {
  case table.lookup(cache, key) {
    [] -> Error(Nil)
    [#(_, v), ..] -> Ok(v)
  }
}

@target(erlang)
pub fn memoize(with cache: Cache(k, v), this key: k, apply fun: fn() -> v) -> v {
  case get(from: cache, fetch: key) {
    Ok(value) -> value
    Error(Nil) -> {
      let result = fun()
      set(in: cache, for: key, insert: result)
      result
    }
  }
}
