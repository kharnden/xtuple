﻿select private.create_model(

-- Model name, schema, table

'item_substitute', 'public', 'itemsub',

-- Columns

E'{
  "itemsub.itemsub_id as id",
  "itemsub.itemsub_parent_item_id as root_item",
  "itemsub.itemsub_sub_item_id as substitute_item",
  "itemsub.itemsub_uomratio as conversion_ratio",
  "itemsub.itemsub_rank as rank"
}',

-- Rules

E'{"

-- insert rule

create or replace rule \\"_CREATE\\" as on insert to xm.item_substitute
  do instead

insert into itemsub (
  itemsub_id,
  itemsub_parent_item_id,
  itemsub_sub_item_id,
  itemsub_uomratio,
  itemsub_rank )
values (
  new.id,
  new.root_item,
  new.substitute_item,
  new.conversion_ratio,
  new.rank );

","

-- update rule

create or replace rule \\"_UPDATE\\" as on update to xm.item_substitute
  do instead

update itemsub set
  itemsub_sub_item_id = new.substitute_item,
  itemsub_uomratio = new.conversion_ratio,
  itemsub_rank = new.rank
where ( itemsub_id = old.id );

","

-- delete rule

create or replace rule \\"_DELETE\\" as on delete to xm.item_substitute
  do instead

delete from itemsub
where ( itemsub_id = old.id );

"}',

-- Conditions, Comment, System

'{}', 'Item Substitute Model', true);
