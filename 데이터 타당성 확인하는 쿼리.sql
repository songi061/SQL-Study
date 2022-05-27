--<로그 데이터의 요건을 만족하는지 확인하는 쿼리>
select
 action

 --session은 반드시 null이 아니어야 함
 ,avg(case when session is not null then 1.0 else 0.0 end) as session

 --user_id는 반드시 null이 아니어야 함
 ,avg(case when user_id is not null then 1.0 else 0.0 end) as user_id

 --category는 action=view일 경우 null, 이외의 경우 null이 아니어야 함
 , avg(
   case action
    when 'view' then
     case when category is null then 1.0 else 0.0 end
    else
     case when category is not null then 1.0 else 0.0 end
  end  
 ) as category

 --products는 action = view 일 경우 null, 이외의 경우 null 이 아니어야 함
 , avg(
   case action
    when 'view' then
     case when products is null then 1.0 else 0.0 end
    else
     case when products is not null then 1.0 else 0.0 end
  end 
 ) as products

 --amount는 action = purchase의 경우 null이 아니어야 하며 이외의 경우는 null
 , avg(
    case action
     when 'purchase' then
      case when amount is not null then 1.0 else 0.0 end
    else
     case when amount is null then 1.0 else 0.0 end
  end  
 ) as amount


 --stamp는 반드시 null이 아니어야 함
 ,avg(case when stamp is not null then 1.0 else 0.0 end) as stamp

from
 `sql-study-349216.ch7.invalid_action_log`
group by
 action
;
