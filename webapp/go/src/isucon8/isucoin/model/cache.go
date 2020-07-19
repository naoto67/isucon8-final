package model

import (
	"encoding/json"
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

func IncrUserFailures(bankID string) error {
	b, _ := json.Marshal(0)
	memClient.Add(&memcache.Item{Key: bankID, Value: b})
	_, err := memClient.Increment(bankID, 1)
	return err
}

func FetchUserFailures(bankID string) (int64, error) {
	data, err := memClient.Get(bankID)
	if err != nil {
		return 0, nil
	}

	var count int64
	err = json.Unmarshal(data.Value, &count)
	return count, err
}

func DeleteUserFailures(bankID string) error {
	return memClient.Delete(bankID)
}

func FlushAll() {
	memClient.FlushAll()
}
