# sudo...KU

<div align="center">
  <img src="./preview.webp" style="max-height: 300px" />
</div>

A simple sudoku game app with some data persistance!

## Building / Developing

1. Install [fvm](https://github.com/leoafarias/fvm)
2. Install the project Flutter version:

```sh
fvm install
```

3. Install the dependencies:

```sh
fvm flutter pub get
```

4. Generate the source code, either using the watcher (generates files on the fly) or by directly building:

```sh
fvm dart run build_runner watch --delete-conflicting-outputs # watcher
fvm dart run build_runner build --delete-conflicting-outputs # simple builder
fvm dart run build_runner clean # cleans the cache if something goes wrong
```

## Dependencies update

```sh
fvm flutter pub upgrade --major-versions
```

> Run this at least once a month

## Flutter update via fvm

```sh
fvm releases # shows the available versions of flutter to install locally
fvm use x.x.x # sets as active the new flutter version
```

## Splash screen generation

```sh
fvm dart run flutter_native_splash:create --path=flutter_native_splash.yaml
```

## Launcher icon generation

```sh
fvm dart run flutter_launcher_icons:generate # Init of flutter_launcher_icons.yaml
fvm dart run flutter_launcher_icons:generate -o # Overrides old yaml
fvm dart run flutter_launcher_icons # Generates all the native files (based on yaml content)
```

## Mason commands

```sh
mason init
mason add brick-name # Adds the brick to the project
mason make brick-name # Executes the brick
```
