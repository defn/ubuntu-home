//usr/bin/env gorun "$0" "$@"; exit "$?"

package main

import (
	"os"
)

func main() {
	println("Hello world!")
	os.Exit(42)
}
