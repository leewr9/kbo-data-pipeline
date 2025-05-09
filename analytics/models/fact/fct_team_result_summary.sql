with result_summary as (
	select 
        "SEASON_ID", 
        "TEAM_NM",
        sum(case when cast("IS_HOME" as boolean) then "B_SCORE_CN" else "T_SCORE_CN" end) as "R_CN",
        sum(case when cast("IS_HOME" as boolean) then "T_SCORE_CN" else "B_SCORE_CN" end) as "RA_CN",
		round(avg(case when cast("IS_HOME" as boolean) then "B_SCORE_CN" else "T_SCORE_CN" end), 3) as "R_AVG",
		round(avg(case when cast("IS_HOME" as boolean) then "T_SCORE_CN" else "B_SCORE_CN" end), 3) as "RA_AVG",
		max(case when cast("IS_HOME" as boolean) then "H_W_CN" else "A_W_CN" end) as "W_CN",
		max(case when cast("IS_HOME" as boolean) then "H_L_CN" else "A_L_CN" end) as "L_CN",
		max(case when cast("IS_HOME" as boolean) then "H_D_CN" else "A_D_CN" end) as "D_CN"
    from {{ ref('stg_game_result_vs') }}
    where "SR_ID" = 0
    group by "SEASON_ID", "TEAM_NM"
	order by "SEASON_ID", "TEAM_NM"
)

select 
    *,
    round(("W_CN" + "D_CN" * 0.5) * 1.0 / ("W_CN" + "L_CN" + "D_CN"), 3) as "W_RATE" 
from result_summary
