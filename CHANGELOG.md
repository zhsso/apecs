## [Unreleased]

## [0.4.0.0]
### Added
- A changelog

### Changed
- `Store` is now split into 5 separate type classes; `ExplInit`, `ExplGet`, `ExplSet`, `ExplDestroy`, and `ExplMembers`.
    This it illegal to e.g. iterate over a `Not`.
- phantom arguments are now given as `Proxy` values, re-exported from `Data.Proxy`. This makes phantom arguments explicit and avoids undefined values.
