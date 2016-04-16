box.cfg {
  log_level = 5;
  listen = 10001;
}

-- Shortcat for space
workers = box.space.workers

if not workers then
  box.schema.user.grant('guest', 'read,write,execute', 'universe')
  workers = box.schema.create_space('workers')
  workers:create_index('primary', {parts={1, 'NUM'}})
  workers:create_index('name', {parts={2, 'STR'}, unique=false})
end
--
-- CREATE TABLE workers (id int primary key, varchar(XXX) name, salary int);
--

-- Functions
function add(name, salary)
  local id = workers.index.primary:max() -- [ID, NAME, SALARY]
  if id == nil then
    id = 0
  else
    id = id[1] + 1 -- [ 1-> ID, 2-> NAME, 3-> SALARY]
  end
  workers:insert{id, name, salary}
  return {id, name, salary}
end

function get(name)
  return {workers.index.name:select{name}}
end

function get_max_salary()
  local id = -1
  local name = ''
  local max = -1
  for _, v in workers:pairs() do
    if v[3] and v[3] > max then
      id = v[1]
      name = v[2]
      max = v[3]
    end
  end
  return {id, name, max}
end


