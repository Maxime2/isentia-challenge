-- test trigger works as expected
-- we use negative values of dp_id here to not interfere with
-- values come from dpsearch
INSERT INTO news VALUES (-1,
       'test://1',
       'Title',
       'headline',
       'author',
       'keywords',
       'description',
       'body');

select * from news where dp_id < 0;

delete from news where dp_id < 0;
