--<예약 IP 주소를 정의한 마스터 테이블 생성 쿼리>
WITH
mst_reserved_ip as (
            select '127.0.0.0/8' as network, 'localhost' as description
  union all select '10.0.0.0/8' as network, 'private network' as description
  union all select '172.16.0.0/12' as network, 'private network' as description
  union all select '192.0.0.0/24' as network, 'private network' as description
  union all select '192.168.0.0/16' as network, 'private network' as description
  
)
select *
from mst_reserved_ip
;
