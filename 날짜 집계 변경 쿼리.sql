--<날짜 집계 범위를 오전 4시부터로 변경하는 쿼리>

with
 action_log_with_mod_stamp as (
  select *
   --4시간 전의 시간 계산하기
   ,cast(timestamp_sub(timestamp(stamp), interval 4 hour) as string ) as mod_stamp
  from `sql-study-349216.ch7.action_log`
)
select
  session 
  , user_id
  , action 
  , stamp  
  -- 원래 타임스탬프와 4시간 후를 나타내는 타임스탬프 추출하기
  ,substr(stamp , 1 , 10) as raw_date
  , substr(mod_stamp, 1, 10) as mod_date
from action_log_with_mod_stamp;
