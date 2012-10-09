### Should be customized to do a table import, a redmine example that is not workink at the moment

# "id", "name", "description", "homepage", "is_public", "parent_id", "created_on", "updated_on", "identifier", "status", "lft", "rgt"
json = JSON.parse(File.read('tmp/Project.json'))
json.each do |js|
  x = Project.new do
      id = js["id"]
      name = js["name"]
      description = js["description"]
      homepage = js["homepage"]
      is_public = js["is_public"]
      parent_id = js["parent_id"]
      created_on = js["created_on"]
      updated_on = js["updated_on"]
      identifier = js["identifier"]
      status = js["status"]
  end
  puts x
  x.save
end
