postgres:
	docker run --name postgres16 -p 25432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:16

createdb:
	docker exec -it postgres16 createdb --username=root --owner=root bank_db

dropdb:
	docker exec -it postgres16 dropdb bank_db

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:25432/bank_db?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:25432/bank_db?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover -count=1 ./...

server:
	go run main.go

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server

