# frozen_string_literal: true

desc "Find tagged OSM nodes"
task match_osm: :environment do
  MatchOsm.call
end
