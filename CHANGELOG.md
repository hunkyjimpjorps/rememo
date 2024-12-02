# Changelog

## v3.1.0 - 24-12-2

* Changed the JS implementation to avoid a pitfall with reference equality causing the cache to be useless for more complicated key types

## v3.0.0 - 24-12-1

* Switched to a default implementation in `rememo/memo`, which will use the ETS implementation on the Erlang target and a new Javascript map implementation on the JS target. You can no longer import a specific implementation.
* Dropped the OTP implementation since it was strictly slower than the ETS one.

## v2.0.0 - 24-04-18

* Added the [Erlang Term Storage](https://www.erlang.org/doc/man/ets.html) implementation as `rememo/ets/memo`.  This has reduced overhead compared to the original OTP implementation, which required message-passing to a `gleam_otp/actor` holding the memoization state.
* The original module was renamed from `rememo` to `rememo/otp/memo`.
* Fixed a bug with the OTP implementation that was unnecessarily updating the cache with K-V pairs that already existed

## v1.0.0 -- 24-04-16

* Initial release.
