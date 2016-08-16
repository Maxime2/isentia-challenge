DROP TABLE IF EXISTS news;
CREATE TABLE news (
       dp_id integer NOT NULL,
       url   text NOT NULL,
       title text,
       headline	text,
       author	text,
       keywords	text,
       description	text,
       body	text
);
create unique index news_idx on news (dp_id);

       
CREATE EXTENSION IF NOT EXISTS plsh;


CREATE OR REPLACE FUNCTION tomongo_insert(text, integer, text, text, text,
       text, text, text) RETURNS void LANGUAGE plsh2 AS
$BODY$
#!/usr/bin/python
import pymongo
import sys
connection = pymongo.MongoClient("localhost", 27017)
db = connection["news"]
collection = db["guardian"]
collection.insert(dict([('dp_id', sys.argv[1]),('body', sys.stdin.read()),('url', sys.argv[2]),('title', sys.argv[3]),('headline', sys.argv[4]),('author', sys.argv[5]),('keywords', sys.argv[6]),('description', sys.argv[7])]))
$BODY$
  COST 200;


CREATE OR REPLACE FUNCTION tr_news_insert_register()
       RETURNS TRIGGER AS
$triggerBODY$
begin

	perform tomongo_insert(NEW.body, NEW.dp_id, NEW.url, NEW.title, NEW.headline,
		NEW.author, NEW.keywords, NEW.description);
-- Actually we do not need to insert data into PgSQL as it's sent into Mongo
-- So we can return NULL when testing is done and for production
	return NEW;

end;
$triggerBODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER tr_news_before_insert
BEFORE INSERT
ON news
FOR EACH ROW
EXECUTE PROCEDURE tr_news_insert_register();

