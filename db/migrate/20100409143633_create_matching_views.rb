class CreateMatchingViews < ActiveRecord::Migration
  def self.up
    execute("create view vuser_activities as select distinct `user_place_activities`.`user_id` AS `user_id`,`user_place_activities`.`activity_id` AS `activity_id` from `user_place_activities`")
    execute("create view vuser_places as select distinct `user_place_activities`.`user_id` AS `user_id`,`user_place_activities`.`place_id` AS `place_id` from `user_place_activities`")
    execute("create view vuser_places_match as select `U1`.`id` AS `U1`,`U2`.`id` AS `U2`,count(0) AS `place_count` from (((`users` `U1` join `vuser_places` `P1` on((`P1`.`user_id` = `U1`.`id`))) join `vuser_places` `P2` on((`P2`.`place_id` = `P1`.`place_id`))) join `users` `U2` on((`U2`.`id` = `P2`.`user_id`))) where (`U1`.`id` <> `U2`.`id`) group by `U1`.`id`,(`U2`.`id` and (`P1`.`place_id` <> 1))")
    execute("create view vuser_activities_match as select `U1`.`id` AS `U1`,`U2`.`id` AS `U2`,count(`A1`.`activity_id`) AS `activity_count` from (((`users` `U1` join `vuser_activities` `A1` on((`A1`.`user_id` = `U1`.`id`))) join `vuser_activities` `A2` on((`A2`.`activity_id` = `A1`.`activity_id`))) join `users` `U2` on((`U2`.`id` = `A2`.`user_id`))) where ((`U1`.`id` <> `U2`.`id`) and (`A1`.`activity_id` <> 1)) group by `U1`.`id`,`U2`.`id` ")
    execute("create view vmatches as select `A`.`U1` AS `U1`,`A`.`U2` AS `U2`,(`A`.`activity_count` + `P`.`place_count`) AS `C` from (`vuser_activities_match` `A` join `vuser_places_match` `P` on(((`A`.`U1` = `P`.`U1`) and (`A`.`U2` = `P`.`U2`)))) union select `A`.`U1` AS `U1`,`A`.`U2` AS `U2`,`A`.`activity_count` AS `C` from (`vuser_activities_match` `A` left join `vuser_places_match` `P` on(((`A`.`U1` = `P`.`U1`) and (`A`.`U2` = `P`.`U2`)))) where (`A`.`activity_count` is not null) union select `A`.`U1` AS `U1`,`A`.`U2` AS `U2`,`P`.`place_count` AS `C` from (`vuser_places_match` `P` left join `vuser_activities_match` `A` on(((`A`.`U1` = `P`.`U1`) and (`A`.`U2` = `P`.`U2`)))) where (`P`.`place_count` is not null)")

  end

  def self.down
    execute("drop view vuser_activities")
    execute("drop view vuser_places")
    execute("drop view vuser_places_match")
    execute("drop view vuser_activities_match")
    execute("drop view vmatches")

  end
end
