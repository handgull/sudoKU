# sudoku

A simple sudoku game app

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
fvm flutter pub run build_runner watch --delete-conflicting-outputs # watcher
fvm flutter pub run build_runner build --delete-conflicting-outputs # simple builder
```

## Dependencies update

```sh
fvm flutter pub upgrade --major-versions
```

> Run this at least once a month

## Fluuter update via fvm

```sh
fvm releases # shows the available versions of flutter to install locally
fvm use x.x.x # sets as active the new flutter version
```
