require 'json'

def get_modules
  m = Module.constants.select do |constant_name|
    constant = eval constant_name.to_s
    if not constant.nil? and constant.is_a? Class and constant.superclass == ActiveRecord::Base
      constant
    end
  end
  m
end

def do_backup
  get_modules.each do |mod|
    klass = eval mod
    data = klass.all.to_json
    write_file mod, data
  end
end

def write_file(filename, data)
  f = File.open "#{filename}.json", 'w'
  f.write data
  f.close
end

do_backup
