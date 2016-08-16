#


.PHONY: setup

setup:
	-@dropdb isentia
	@createdb isentia
	/usr/local/dpsearch/sbin/indexer -Ecreate ./indexer.conf
	@psql isentia < create_news.sql


test:
	@echo
	@echo You should see one record inserted into news table with dp_id = -1
	@echo
	@psql isentia < trigger_test.sql
	@echo
	@echo you should see the same record in mongodb guardian collection
	@echo
	@mongo < trigger_test.js
	@echo
	@echo All test records were deleted
	@echo

crawl:
	/usr/local/dpsearch/sbin/indexer -N8 -n200 ./indexer.conf
