
select *  from matches
select * from deliveries
---top 5 player of the match--

select top 5  player_of_match,count(*) as awards_count  from matches
group by player_of_match
order by awards_count desc

----season winner + no of matches win by team

select season,winner,count(*) as total_wins  from matches 
group by season,winner
order by season 

---Avg Strike rate of the batsman in the ipl dataset---

select avg(strike_rate) as average_strike_rate
from (
    select batsman, (sum(total_runs) * 100.0) / count(ball) as strike_rate
    from deliveries
    group by batsman
) as batsman_stats;

---Number of matches winning by the teams while batting first

select batting_first ,count(*) as matches_won  from 
(select case when win_by_runs>0 then team1
else team2 end as batting_first from matches
where result!='tie') as batting_first_teams
group by batting_first

----Player Having highest strike_rate---
select top 1 batsman,(sum(batsman_runs) *100)/count(*) as highest_strike_rate from deliveries
group by batsman 
having sum(batsman_runs)>=200
order by highest_strike_rate desc

---batsman Dismiised by malinga---

select batsman,count(*) as malinga_dismissed
from deliveries
where bowler='SL Malinga' and player_dismissed is not null
group by batsman


---average Boundries by batsman---
select batsman,avg(case when batsman_runs = 4 or batsman_runs = 6 then 1 else 0 end )  * 100 as average_boudries  from deliveries
group by batsman

---average boundries by team=/--

Select season,batting_team,avg(fours+sixes) as avg_boundries from 
(select season,batting_team,match_id,
sum(case when batsman_runs=4 then 1 else 0 end)
as fours,
sum(case when batsman_runs=6 then 1 else 0 end) as sixes
 from deliveries,matches
 where deliveries.match_id=matches.id
 group by season,batting_team,match_id) as team_boundries
 group by season,batting_team
 ---Highest Partership runs for each season--
 select season,batting_team,max(total_runs) as highest_partership
 from(
 select season,batting_team,partnership,over_no,sum(total_runs) as Total_runs from 
 (
 select sum(batsman_runs) as partner_ship,
 sum(batsman_runs)+sum(extras) as total_runs
 from   deliveries,matches
 where deliveries.match_id=matches.id
 group by season,batting_team,over) as total_runs
 group by season,batting_team,partnership) as highest_partership
 group by season,batting_team

--no of wides bowled by each team in each match--

select m.id as match_no,d.bowling_team,sum(d.extra_runs) as extras
from matches m join deliveries d
on m.id = d.match_id
where extra_runs>0
group by  m.id,d.bowling_team
---most wickets taken in single match--
select top 1
m.id as match_no
,d.bowler ,count(*) as wicket_taken
  from matches m join deliveries d
on m.id = d.match_id
where player_dismissed is not null
group by m.id,d.bowler
order by 3 desc

---most teams wins in city--
SELECT 
    m.city,
   (CASE 
        WHEN m.team1 = m.winner THEN m.team1
        WHEN m.team2 = m.winner THEN m.team2
        ELSE 'Draw'  
    END)  team_wins,
    COUNT(*) AS match_count
FROM 
    matches m 
JOIN 
    deliveries d ON m.id = d.match_id
WHERE 
    m.result != 'Tie'
GROUP BY 
    m.city,
team_wins;
--Toss winner Per Season--

select season,toss_winner,count(*) as tosses_won from matches
group by season,toss_winner
order by 3 desc

--most Player of the matches--

select player_of_match,count(*) as total_wins from 
matches
group by player_of_match
order by 2 desc