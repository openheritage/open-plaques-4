# frozen_string_literal: true

desc "Match with tagged Flickr photos"
task match_flickr: :environment do
  MatchFlickr.call
end
