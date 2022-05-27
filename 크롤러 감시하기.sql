--<접근이 많은 사용자 에이전트를 확인하는 쿼리>
with
mst_bot_user_agent as(
             select '%bot%'      as rule
  union all  select '%crawler%'  as rule
  union all  select '%spider%'   as rule
  union all  select '%archiver%' as rule
)
, filtered_action_log as(
  select
    l.stamp, l.session, l.action, l.products
    , l.url , l.ip, l.user_agent
  --UserAgent의 규칙에 해당하지 않는 로그만 남기기 => Where 구문에 상관 서브쿼리를 사용할 수 있음
  from
  `sql-study-349216.ch7.action_log_with_noise` as l
  where
   not exists (
     select 1
     from mst_bot_user_agent as m   
     where
     l.user_agent like m.rule 
   )
)  
select
  user_agent
  , count(1) as count
  , 100.0
  * sum(count(1)) over(order by count(1) desc
   rows between unbounded preceding and current row)
   / sum(count(1)) over() as cumulative_ratio
from
  filtered_action_log
group by
  user_agent
order by
  count desc
;
