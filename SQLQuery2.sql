select  id1.location, id1.date, id1.population, id2.new_vaccinations,id2.total_vaccinations,
sum(convert(int,new_vaccinations)) over (partition by id1.location order by  id1.date ) as rollingcount
from PortifolioCovid..covid1 id1
join PortifolioCovid..covid2 id2
on id1.location = id2.location and id1.date = id2.date
where id1.location='Brazil'

--use cte
with CTEpercvacc(location, date, population, new_vaccinations, total_vaccinations, rollingcount) 
as
(
select  id1.location, id1.date, id1.population, id2.new_vaccinations,id2.total_vaccinations,
sum(convert(int,new_vaccinations)) over (partition by id1.location order by  id1.date ) as rollingcount
from PortifolioCovid..covid1 id1
join PortifolioCovid..covid2 id2
on id1.location = id2.location and id1.date = id2.date
where id1.location='Brazil'
)
select *, (rollingcount/population)*100 as Percvacc from  CTEpercvacc


select location, population, date, people_fully_vaccinated, ( people_fully_vaccinated/population)*100 PercVacc  from  covid2
where location= 'Brazil' and people_fully_vaccinated is not null
order by date desc

-- temp table 


drop table if exists #PercentPopulationVaccinated 
create table #PercentPopulationVaccinated
(
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations  numeric,
total_vaccinations numeric,
rollingcount numeric)

insert into #PercentPopulationVaccinated
select  id1.location, id1.date, id1.population, id2.new_vaccinations,id2.total_vaccinations,
sum(convert(int,new_vaccinations)) over (partition by id1.location order by  id1.date ) as rollingcount
from PortifolioCovid..covid1 id1
join PortifolioCovid..covid2 id2
on id1.location = id2.location and id1.date = id2.date
where id1.location='Brazil'

select *, (rollingcount/population)*100 as Percvacc from  #PercentPopulationVaccinated



-- creating view to store data for BI
create view PercentPopulationVaccinated as 
select  id1.location, id1.date, id1.population, id2.new_vaccinations,id2.total_vaccinations,
sum(convert(int,new_vaccinations)) over (partition by id1.location order by  id1.date ) as rollingcount
from PortifolioCovid..covid1 id1
join PortifolioCovid..covid2 id2
on id1.location = id2.location and id1.date = id2.date
where id1.location='Brazil'

select*from PercentPopulationVaccinated
