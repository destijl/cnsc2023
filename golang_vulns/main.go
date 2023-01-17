package main

import (
	"fmt"
	_ "net/http"
	_ "encoding/xml"

	_ "golang.org/x/crypto/ssh"
)

func main() {
	message := "Hello world!"
	fmt.Println(message)
}
