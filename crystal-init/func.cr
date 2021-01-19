require "http/server"
require "json"
require "helper"

my_proc = ->(input : JSON::Any) do
  name = input["name"]? || "world"
  %({"message": "Hello #{name}"})
end

FnHelper.handle &my_proc
