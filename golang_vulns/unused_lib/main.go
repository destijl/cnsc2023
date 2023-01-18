package main

import (
	"fmt"

	_ "golang.org/x/crypto/ssh"
)

func main() {
	message := "Hello world!"
	fmt.Println(message)
}
