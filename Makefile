run_local:
	docker-compose -f webapp/docker-compose.go.yml -f webapp/docker-compose.yml up -d
	docker-compose -f blackbox/docker-compose.local.yml up -d

run_app:
	docker-compose -f webapp/docker-compose.go.yml -f webapp/docker-compose.yml up

restart_app:
	docker-compose -f webapp/docker-compose.go.yml -f webapp/docker-compose.yml restart

run_blackbox:
	docker-compose -f blackbox/docker-compose.local.yml up -d

### isubankとisuloggerはnginxを経由していない
.PHONY: bench
bench: clean_log
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

cat_alp:
	cat webapp/nginx/log/access.log | alp ltsv -r -m "/order/.+" --sort=sum | head -n 30

mysql_console:
	docker-compose -f webapp/docker-compose.go.yml run isucoin mysql -uisucon -pisucon -h192.168.16.3 isucoin

clean_log:
	cp /dev/null webapp/nginx/log/access.log
