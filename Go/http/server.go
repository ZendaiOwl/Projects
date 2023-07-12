package main

import (
	"fmt"
	"net/http"
)

var pl = fmt.Println

func Hello(name string) string {
	return "Hello " + name
}

func main() {
	pl(Hello("Ray"))
}

func PlayerServer(w http.ResponseWriter, r *http.Request) {
	
}
