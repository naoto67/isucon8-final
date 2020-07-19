package model

import (
	"fmt"

	"github.com/bradfitz/gomemcache/memcache"
)

var memClient *memcache.Client

func NewMemcache(server string) {
	client := memcache.New(server)
	fmt.Println("cache ping...")
	err := client.Ping()
	if err != nil {
		fmt.Println("failed ping.", err)
		panic(err)
	}
	fmt.Println("PONG!!!")

	memClient = client
}
