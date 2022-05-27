--<IP 주소를 0으로 메운 문자열로 변환하고, 특정 IP로그를 배제하는 쿼리>
WITH
mst_reserved_ip_with_range as (
  select '127.0.0.0/8' as network
      , '127.0.0.0' as network_start_ip
      , '127.255.255.255' as network_last_ip
      , 'localhost' as description
  union all
   select '172.16.0.0/12' as network
      , '172.16.0.0' as network_start_ip
      , '172.31.255.255' as network_last_ip
      , 'private network' as description
  union all
   select '192.0.0.0/24' as network
      , '192.0.0.0' as network_start_ip
      , '192.0.0.255' as network_last_ip
      , 'private network' as description
  union all
   select '192.168.0.0/16' as network
      , '192.168.0.0' as network_start_ip
      , '192.168.255.255' as network_last_ip
      , 'private network' as description
  union all
   select '10.0.0.0/8' as network
      , '10.0.0.0' as network_start_ip
      , '10.255.255.255' as network_last_ip
      , 'private network' as description
)
, action_log_with_ip_varchar as(
  -- 액션 로그의 IP주소를 0으로 메운 문자열로 표현하기
  select
   *
  --빅쿼리의 경우 split 함수를 사용해 배열로 분해하고 n번째 요소 추출하기
  , concat(
    lpad(split(ip, '.')[safe_ordinal(1)], 3, '0')
  , lpad(split(ip, '.')[safe_ordinal(2)], 3, '0')
  , lpad(split(ip, '.')[safe_ordinal(3)], 3, '0')
  , lpad(split(ip, '.')[safe_ordinal(4)], 3, '0')
  )as ip_varchar
from
 `sql-study-349216.ch7.action_log_with_ip`
)
, mst_reserved_ip_with_varchar_range as(
  --마스터 테이블의 ip주소를 0으로 메운 문자열로 표현하기
  select
   *
  --빅쿼리의 경우 split함수를 사용해 배열로 분해하고 n번째 요소 추출하기
  , concat(
    lpad(split(network_start_ip, '.')[safe_ordinal(1)], 3, '0')
  , lpad(split(network_start_ip, '.')[safe_ordinal(2)], 3, '0')
  , lpad(split(network_start_ip, '.')[safe_ordinal(3)], 3, '0')
  , lpad(split(network_start_ip, '.')[safe_ordinal(4)], 3, '0')
  )as network_start_ip_varchar
  , concat(
    lpad(split(network_last_ip, '.')[safe_ordinal(1)], 3, '0')
  , lpad(split(network_last_ip, '.')[safe_ordinal(2)], 3, '0')
  , lpad(split(network_last_ip, '.')[safe_ordinal(3)], 3, '0')
  , lpad(split(network_last_ip, '.')[safe_ordinal(4)], 3, '0')
  )as network_last_ip_varchar
 from
  mst_reserved_ip_with_range
)

--0으로 메운 문자열로 표현한 ip주소로, 네트워크 범위에 포함되는지 판정하기
select
 l.user_id
 , l.ip
 , l.ip_varchar
 , l.stamp
from
  action_log_with_ip_varchar as l
 cross join
  mst_reserved_ip_with_varchar_range as m 
group by
l.user_id, l.ip, l.ip_varchar, l.stamp
--예약된 IP 주소 마스터에 포함되지 않은 IP 로그만 HAVING 구문으로 추출하기
HAVING
 sum(case when l.ip_varchar
   between m.network_start_ip_varchar and m.network_last_ip_varchar
   then 1 else 0 end ) = 0
;
