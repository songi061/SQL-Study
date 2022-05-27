--<네트워크 범위를 나타내는 처음과 끝 ip 주소를 부여하는 쿼리>
WITH
mst_reserved_ip_with_range as (
  --마스터 테이블에 네트워크 범위에 해당하는 ip 주소의 최솟값과 최댓값 추가하기
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
select *
from mst_reserved_ip_with_range;
