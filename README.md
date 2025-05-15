# Template for embassy rp2350 projects

This template is intended as a starting point for writing your own firmware based on the embassy libraries for the rp2350 w/ the CYW43 wireless module (rPi Pico2W)

It includes all of the `knurling-rs` tooling as showcased in <https://github.com/knurling-rs/app-template> (`defmt`, `defmt-rtt`, `panic-probe`, `flip-link`) to make development as easy as possible.

`probe-rs` in SWD mode is configured as the default runner, so you can run your binary with

`this is an in progress port of the much better supported (by upstream libraries) rp2040 embassy template, stuff is broken`

```sh
cargo run --release
```

## Requirements
  
- The standard Rust tooling (cargo, rustup) which you can install from <https://rustup.rs/>

- Toolchain support for the cortex-m33+ processors in the rp2350 (thumbv8m.main-none-eabihf)

- flip-link - this allows you to detect stack-overflows on the first core, which is the only supported target for now.

- A [`probe-rs` compatible](https://probe.rs/docs/getting-started/probe-setup/) probe

- A [`probe-rs` installation](https://probe.rs/docs/getting-started/installation/)

- the [`pico-sdk` repo](https://github.com/raspberrypi/pico-sdk) and [`picotool` repo](https://github.com/raspberrypi/picotool) built.

## Installation of development dependencies

```sh
rustup target install thumbv8m.main-none-eabihf
cargo install flip-link


# Installs the probe-rs tools, including probe-rs run, our recommended default runner
cargo install --locked probe-rs-tools
# or to use a custom git repo (i.e for features not in mainline)
cargo install --git https://github.com/ryan-summers/probe-rs.git --branch feature/rp2350-flashing probe-rs-tools --locked 

```

If you get the error ``binary `cargo-embed` already exists`` during installation of probe-rs, run `cargo uninstall cargo-embed` to uninstall your older version of cargo-embed before trying again.

## Running

For a debug build

```sh
cargo run
```

For a release build

```sh
cargo run --release
```

### For a manual build

if you do not want to use all the 'fancy' tooling it is also possible to just use picotool and a thumbv8 rust tool chain.

```sh
cargo build
cd target/thumbv8m.main-none-eabihf/debug

# connect your pico2w in bootsel mode for use with picotool and flash if required
./flashwb_picotool.sh

# convert compiler output (elf) to uf2
picotool uf2 convert embassy-pico2w-template -t elf embassy-pico2w-template.uf2

# flash uf2 to device and reload to run
picotool load embassy-pico2w-template.uf2
picotool reboot
```

### Logging

If you do not specify a DEFMT_LOG level, it will be set to `debug`.
That means `println!("")`, `info!("")` and `debug!("")` statements will be printed.
If you wish to override this, you can change it in `.cargo/config.toml`

```toml
[env]
DEFMT_LOG = "off"
```

You can also set this inline (on Linux/MacOS)  

```sh
DEFMT_LOG=trace cargo run
```

## Flashing CYW43 WiFI+BT module firmware

If you wish you use the on-board LED or the WiFi/BT module you will need to flash the module firmware.

`NOTE: By default firmware is placed at the 3MiB mark in ROM`

For WiFi + Bluetooth firmware

`./flashwb.sh` *or*  `./flashwb_picotool.sh`

you shouldn't need to relash the firmware again unless you erase the EEPROM or accidentally mess with ROM contents past the 3 MiB mark.
