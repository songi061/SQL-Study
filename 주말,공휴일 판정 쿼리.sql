select
 a.action
 , a.stamp
 , c.dow
 , c.holiday_name
  --주말과 공휴일 판정
  , c.dow_num in (0,6) -- 토요일과 일요일 판정하기
   or c.holiday_name is not null --공휴일 판정하기
   as is_day_off
from
 ch7.access_log as a    
 join
   mst_calendar as c   
   --액션 로그의 타임스탬프에서 연,월,일을 추출하고 결합하기
   on cast(substr(a.stamp, 1, 4) as int64) = c.year
   and cast(substr(a.stamp, 6, 2) as int64) = c.month
   and cast(substr(a.stamp, 9, 2) as int64) = c.day                                
;
