--접근 수가 적은 URL을 상위에 출력할 것이므로, 윈도 함수 내부의 ORDER BY 구문을 오름차순으로 지정하였다.

WITH
url_count as(
  select
    url
    ,count(*) as count
  from
   `sql-study-349216.ch7.action_log_with_noise`
  group by
    url
)
SELECT
 url 
 , count 
 , rank() over(order by count asc) as rank
 , percent_rank() over(order by count asc)
from
 url_count
;
