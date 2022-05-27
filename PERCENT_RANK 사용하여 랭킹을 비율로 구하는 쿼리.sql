--세션별로 페이지 조회 수를 집계하고,  PERCENT_RANK함수를 사용해 페이지 조회수 랭킹을 비율로 구하는 쿼리

with
session_count as(
  select
    session 
    , count(1) as count
    from
    `sql-study-349216.ch7.action_log_with_noise`
    group by
    session
)
select
  session
  ,count
  ,rank() over(order by count desc) as rank
  ,percent_rank() over(order by count desc) as percent_rank
from
  session_count
;
