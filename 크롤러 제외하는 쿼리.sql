select
 *
from
 ch7.action_log_with_noise
where
 not
 --크롤러 판정 조건
 ( user_agent like '%bot%'
   or user_agent like '%crawler%'
   or user_agent like '%spider%'
   or user_agent like '%archiver%'
 )
;
