json.id note.uuid
json.description note.description
json.employeeId note.employee.uuid
json.done note.done

if note.receiver_id.present? && note.receiver_id != note.employee_id
  json.personId note.receiver.uuid
  json.personName note.receiver.name
end
