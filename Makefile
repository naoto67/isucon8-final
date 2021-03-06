run_local:
	docker-compose -f webapp/docker-compose.go.yml -f webapp/docker-compose.yml up -d
	docker-compose -f blackbox/docker-compose.local.yml up -d

### isubankとisuloggerはnginxを経由していない
bench:
	./bench/bin/bench \
	-appep=http://192.168.16.4 \
	-bankep=http://192.168.16.6:5515 \
	-logep=http://192.168.16.8:5516 \
	-internalbank=http://192.168.16.6:5515 \
	-internallog=http://192.168.16.8:5516

down:
	docker-compose -f blackbox/docker-compose.local.yml down
	docker-compose -f webapp/docker-compose.go.yml -f webapp/docker-compose.yml down

build_bench:
	cd bench/src/bench; rm go.mod; go mod init bench
	cd bench/src/bench && go build -v -o bench cmd/bench/main.go
	mv bench/src/bench/bench bench/bin/bench
