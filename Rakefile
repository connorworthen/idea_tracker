ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

Rake::Task["db:migrate"].enhance do
  if ActiveRecord::Base.schema_format == :sql
    Rake::Task["db:schema:dump"].invoke
  end
end