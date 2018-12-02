if @searched_agents.count > 50
  return
end
json.message "ok"
json.count @searched_agents.count + @searched_agencies.count
json.agents do
  json.array! @searched_agents do |agent|
    json.id agent.id
    json.name agent.name
  end
end
json.agencies do
  json.array! @searched_agencies do |agency|
    json.id agency.id
    json.name agency.title
  end
end

