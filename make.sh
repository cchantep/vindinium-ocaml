#! /bin/sh

# Minimal build script

ACTION="$1"
if [ "$1" = "" ]; then
  ACTION="compile"
fi

if [ `dirname $0` = "." ]; then
  BASEDIR="$PWD"
else
  BASEDIR=`dirname $0`
fi

SRCDIR="$BASEDIR/src"
TESTDIR="$BASEDIR/test"
BUILD="$BASEDIR/target"

if [ ! -d "$BUILD" ]; then
  mkdir -p "$BUILD"
fi

MODULES="hero board game state bot random_bot"
MAIN="vindinium"
PROGNAME="vindinium"
TESTS="hero_test tile_fixtures tile_test board_test runner"

function compile {
  echo "Compile sources..."
  SOURCES=""

  for M in $MODULES; do
    cp "$SRCDIR/$M.ml" "$BUILD/"
    SOURCES="$SOURCES $M.ml"
  done

  cp "$SRCDIR/$MAIN.ml" "$BUILD/"
  SOURCES="$SOURCES $MAIN.ml"

  cd "$BUILD" && \
    ocamlfind ocamlopt -o $PROGNAME -linkpkg -thread -package core $SOURCES
}

if [ "$ACTION" = "compile" ]; then (compile); fi

if [ "$ACTION" = "test" ]; then
  echo "Build & run tests..."

  if [ ! -f "$BUILD/$PROGNAME" ]; then
    compile
  fi

  SOURCES=""
  for T in $TESTS; do
    cp "$TESTDIR/$T.ml" "$BUILD/"
    SOURCES="$SOURCES $T.ml"
  done

  DEPS=`echo "$MODULES" | sed -e 's/ /.cmx /g;s/$/.cmx/'`

  cd "$BUILD" && \
    ocamlfind ocamlopt -o "run_tests" -linkpkg -thread \
      -package core -package oUnit $DEPS $SOURCES && \
    ./run_tests
fi

if [ "$ACTION" = "clean" ]; then
  echo "Clean build files..."
  rm -rf "$BUILD"
fi
