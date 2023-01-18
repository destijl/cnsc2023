package main

import (
	"fmt"

	"golang.org/x/crypto/ssh"
)

func main() {
	_, _, _, err := ssh.NewServerConn(nil, nil)
	if err != nil {
		fmt.Println(err)
	}
	message := "Hello world!"
	fmt.Println(message)
}
