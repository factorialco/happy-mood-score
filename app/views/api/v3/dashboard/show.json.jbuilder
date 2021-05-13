json.resultsBad @dashboard[:total_bad]
json.resultsGood @dashboard[:total_good]
json.resultsFine @dashboard[:total_fine]
json.totalVotes @dashboard[:total_votes]
json.totalCount @dashboard[:total_count]
json.totalPending @dashboard[:total_pending]
json.involvement @dashboard[:involvement]
json.totalHms @dashboard[:hms]
json.companyName @dashboard[:company_name]
if @resource_type == 'team'
  json.teamId @dashboard[:team_uuid]
  json.teamName @dashboard[:team_name]
elsif @resource_type == 'employee'
  json.employeeId @dashboard[:employee_uuid]
  json.employeeName @dashboard[:employee_name]
end
