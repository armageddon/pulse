class CreateMatchingViews < ActiveRecord::Migration
  def self.up
     execute("create view vuser_activities as select distinct `user_place_activities`.`user_id` AS `user_id`,`user_place_activities`.`activity_id` AS `activity_id` from `user_place_activities`")
     execute("create view vuser_places as select distinct `user_place_activities`.`user_id` AS `user_id`,`user_place_activities`.`place_id` AS `place_id` from `user_place_activities`")
     execute("create view vuser_places_match as select `U1`.`id` AS `U1`,`U2`.`id` AS `U2`,count(0) AS `place_count` from (((`users` `U1` join `vuser_places` `P1` on((`p1`.`user_id` = `U1`.`id`))) join `vuser_places` `P2` on((`p2`.`place_id` = `p1`.`place_id`))) join `users` `U2` on((`U2`.`id` = `p2`.`user_id`))) where (`U1`.`id` <> `U2`.`id`) group by `U1`.`id`,(`U2`.`id` and (`p1`.`place_id` <> 1))")
     execute("create view vuser_activities_match as select `U1`.`id` AS `U1`,`U2`.`id` AS `U2`,count(`a1`.`activity_id`) AS `activity_count` from (((`users` `U1` join `vuser_activities` `A1` on((`a1`.`user_id` = `U1`.`id`))) join `vuser_activities` `A2` on((`a2`.`activity_id` = `a1`.`activity_id`))) join `users` `U2` on((`U2`.`id` = `a2`.`user_id`))) where ((`U1`.`id` <> `U2`.`id`) and (`a1`.`activity_id` <> 1)) group by `U1`.`id`,`U2`.`id` ")
     execute("create view vmatches as select `a`.`U1` AS `U1`,`a`.`U2` AS `U2`,(`a`.`activity_count` + `p`.`place_count`) AS `c` from (`vuser_activities_match` `A` join `vuser_places_match` `P` on(((`a`.`U1` = `p`.`U1`) and (`a`.`U2` = `p`.`U2`)))) union select `a`.`U1` AS `U1`,`a`.`U2` AS `U2`,`a`.`activity_count` AS `c` from (`vuser_activities_match` `A` left join `vuser_places_match` `P` on(((`a`.`U1` = `p`.`U1`) and (`a`.`U2` = `p`.`U2`)))) where (`a`.`activity_count` is not null) union select `a`.`U1` AS `U1`,`a`.`U2` AS `U2`,`p`.`place_count` AS `c` from (`vuser_places_match` `P` left join `vuser_activities_match` `A` on(((`a`.`U1` = `p`.`U1`) and (`a`.`U2` = `p`.`U2`)))) where (`p`.`place_count` is not null)")

  end

  def self.down
  end
end
