# frozen_string_literal: true

begin
  require "duel/rake_task"
  Duel::RakeTask.new
rescue LoadError
  # duel requires Ruby 3.4 or later
end
