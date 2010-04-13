class NewMatchingViews < ActiveRecord::Migration
  def self.up

    execute("DROP VIEW vuser_places_match")
    execute("CREATE VIEW vuser_places_match as
    select P1.user_id AS U1,P2.user_id AS U2,count(0) AS place_count
    from vuser_places P1
    join vuser_places P2 on p2.place_id = p1.place_id
    where P1.user_id <> P2.user_id
    and P1.place_id <> 1
    group by P1.user_id,P2.user_id
    ")

    execute("CREATE VIEW vmatches_all as
      select U1.id as U1, U2.id as U2 from users U1, users U2
      where U1.sex_preference = U2.sex
      and U1.age_preference in (U2.age-1,U2.age,U2.age+1)
      and U1.sex = U2.sex_preference
      and U1.age in ( U2.age_preference-1,U2.age_preference,U2.age_preference+1)
      and U1.id <> U2.id
      order by U1.id
      ")

    execute("DROP VIEW vmatches")
    execute("CREATE VIEW vmatches as
    select A.U1 AS U1,A.U2 AS U2, A.activity_count + P.place_count AS C , A.activity_count as A, P.place_count AS P
    from vuser_activities_match A join vuser_places_match P on A.U1 = P.U1 and A.U2 = P.U2
    union
    select A.U1 AS U1,A.U2 AS U2,A.activity_count AS C, A.activity_count as A, null AS P
    from vuser_activities_match A
    left join vuser_places_match P on A.U1 = P.U1 and A.U2 = P.U2
    where A.activity_count is not null
    union
    select A.U1 AS U1,A.U2 AS U2,P.place_count AS C, null as A, P.place_count AS P
    from vuser_places_match P
    left join vuser_activities_match A on A.U1 = P.U1 and A.U2 = P.U2
    where P.place_count is not null")

    execute("CREATE VIEW vmatcher as
    SELECT A.U1 as U1 , A.U2 as U2, MAX(V.C) as C, max(V.A) as A,max( V.P) as P
    FROM vmatches_all A
    left join vmatches V on V.U1 = A.U1 and V.U2 = A.U2
    GROUp BY U1,U2
    ORDER BY V.C DESC
      ")

    end

    def self.down

    end
  end
