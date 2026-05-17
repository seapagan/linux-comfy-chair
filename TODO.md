# TODO

## Low-Space and Low-Memory Systems

Notes from testing on a Raspberry Pi 3 with 1 GB RAM and Raspberry Pi OS Trixie
arm64.

- Rust tool installs can fail on low-memory systems when `cargo` runs multiple
  compiler jobs in parallel. `cargo-edit` failed with `rustc` killed by
  `SIGKILL`, while RAM and swap were heavily used.
- Some systems mount `/tmp` as a small `tmpfs`. On the Pi 3 test system, `/tmp`
  was 453 MB and filled during `cargo install bob-nvim`, causing `No space left
  on device`. The leftover failed cargo build directories used about 454 MB.
- `pyenv` also failed once `/tmp` was full, so this is not Rust-specific. Other
  source-build tools such as `ruby-build`, `python-build`, CPAN, and cargo may
  all hit the same small tmpfs limit.
- Defaulting the whole bootstrap run to a project-specific temporary directory,
  such as `$HOME/.cache/comfy-chair/tmp`, is probably a sensible fix. It avoids
  small `/tmp` mounts, uses normal user disk space, and should not slow down
  normal systems.
- Be more cautious with defaulting `CARGO_BUILD_JOBS=1`: it may fix Pi 3-class
  memory pressure, but it will slow Rust installs on machines with enough RAM.
  Keep it as a documented/manual workaround unless testing proves it is needed
  automatically.
- Decide whether failed build artifacts in the project-specific temporary
  directory should be cleaned automatically, or left in place for debugging and
  reuse.
- If the workaround is reliable, document the manual low-resource command form:

  ```bash
  mkdir -p "$HOME/.cache/comfy-chair/tmp"
  export TMPDIR="$HOME/.cache/comfy-chair/tmp"
  CARGO_BUILD_JOBS=1 cargo install <tool>
  ```
