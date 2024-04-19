# Changelog

## v2.0.0 - 24-04-18

* Added the [Erlang Term Storage](https://www.erlang.org/doc/man/ets.html) implementation as `rememo/ets/memo`.  This has reduced overhead compared to the original OTP implementation, which required message-passing to a `gleam_otp/actor` holding the memoization state.
* The original module was renamed from `rememo` to `rememo/otp/memo`.
* Fixed a bug with the OTP implementation that was unnecessarily updating the cache with K-V pairs that already existed

## v1.0.0 -- 24-04-16

* Initial release.
