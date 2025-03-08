select date_trunc('week', visit_dt) as period,
       count(distinct visitor) as visitors, 
       count(distinct usr) as users,
       count(distinct usr)*1.0/greatest(count(distinct visitor), 1) as "conv users/clients",
       -- here func greates between actual value and 1 - is for case when actual value = 0 and dividing by 0 throw error
       count(distinct reg_user_id) as regs_users,
       count(distinct reg_user_id)*1.0/greatest(count(distinct visitor), 1) as "conv reg_users/visitors",
       count(distinct reg_user_id)*1.0/greatest(count(distinct usr), 1) as "conv reg_users/users",
       count(distinct dep_user_id) as deposit_users,
       count(distinct dep_user_id)*1.0/greatest(count(distinct visitor), 1) as "conv dep_users/visitors",
       count(distinct dep_user_id)*1.0/greatest(count(distinct usr), 1) as "conv dep_users/users",
       count(distinct order_user_id) as order_users,
       count(distinct order_user_id)*1.0/greatest(count(distinct visitor), 1) as "conv order_users/visitors",
       count(distinct order_user_id)*1.0/greatest(count(distinct usr), 1) as "conv order_users/users"
    from
    (
        select visitor, usr, visit_dt, utm_source, utm_campaign, reg_user_id, dep_user_id, order_user_id
        from
        (
            select distinct visits.client_id as visitor, visits.user_id as usr, visits.created_at as visit_dt, 
                            utm_source, utm_campaign, reg_user_id, dep_user_id, order_user_id
            from visits
            left join 
            (
                select created_at as reg_dt, reg_id, user_id as reg_user_id
                from all_regs
            ) as regs
            on visits.user_id = regs.user_id and visits.created_at < regs.reg_dt
            left join 
            (
                select created_at as dep_dt, dep_id, user_id as dep_user_id
                from all_deposits
            ) as deposits
            on visits.user_id = deposits.user_id and visits.created_at < deposits.dep_dt
            left join
            (
                select created_at as order_dt, order_id, user_id as order_user_id
                from all_orders
            ) as orders
            on visits.user_id = orders.order_user_id and visits.created_at < orders.order_dt          
            where visit_dt > '2025-01-01'
              AND utm_source = 'source1'
              AND utm_campaign = 'campaign1'
        ) as all
        order by visit_dt
    ) as foo2
    group by period
    order by period
