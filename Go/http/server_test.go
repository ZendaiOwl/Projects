package main

import (
	"testing"
	"net/http"
	"net/http/httptest"
)

func TestHello(t *testing.T) {
	got := Hello("Ray")
	want := "Hello Ray"

	if got != want {
		t.Errorf("got %q want %q", got , want)
	}
}

func TestGETPlayers(t *testing.T) {
	t.Run("returns Pepper's score", func(t *testing.T) {
		request, _ := http.NewRequest(http.MethodGet, "/players/Pepper", nil)
		response := httptest.NewRecorder()

		PlayerServer(response, request)

		got := response.Body.String()
		want := "20"

		if got != want {
			t.Errorf("got %q want %q", got, want)
		}
	})
}
