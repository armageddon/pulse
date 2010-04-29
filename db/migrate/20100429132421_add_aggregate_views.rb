class AddAggregateViews < ActiveRecord::Migration
  def self.up
       execute("create view vplaces_count as
select places.id as id  , count(*)  as count
from places inner join user_place_activities UPA on UPA.place_id = places.id
group by places.id
    ")

    execute("create view vactivities_count as
select activities.id as id  , count(*)  as count
from activities inner join user_place_activities UPA on UPA.activity_id = activities.id
group by activities.id  ")


  end

  def self.down
  end
end
