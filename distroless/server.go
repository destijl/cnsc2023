package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
)

var (
	host = flag.String("host", "", "host interface to listen on")
	port = flag.String("port", "8080", "port to listen on")
)

func main() {
	http.HandleFunc("/", HelloServer)
	log.Printf("Server listening on port %s", *port)
	http.ListenAndServe(net.JoinHostPort("", *port), nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, world!")
}
