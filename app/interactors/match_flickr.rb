class MatchFlickr
  include Interactor

  def call
    api_key = ENV.fetch("FLICKR_KEY")
    20.times do |page|
      machine_tag = "openplaques:id="
      api = "https://api.flickr.com/services/rest/?api_key=#{api_key}&format=json&nojsoncallback=1&method=flickr.photos.search&page=#{page}&content_type=1&machine_tags=#{machine_tag}&extras=machine_tags"
      Rails.logger.debug("Flickr: #{api}")
      response = URI.parse(api).open
      doc = JSON.parse(response.read)
      doc["photos"]["photo"].each do |flick_photo|
        Rails.logger.debug("Flickr photo: #{flick_photo}")
        $stdout.flush
        owner = flick_photo["owner"]
        flickr_photo_id = flick_photo["id"]
        url = "https://www.flickr.com/photos/#{owner}/#{flickr_photo_id}/"
        photo = Photo.find_by(url:) || Photo.find_by(url: url.sub("https:", "http:"))
        if photo
          Rails.logger.debug("we have already got that one Photo.find(#{photo.id})")
        else
          id = flick_photo["machine_tags"][/openplaques\:id\=(\d+)/, 1]
          plaque = Plaque.find_by(id:)
          if plaque
            photo = Photo.new(url:, plaque:)
            photo.populate
            photo.save
          else
            Rails.logger.error("Machine tag #{flick_photo["machine_tags"]} does not match a plaque.")
          end
        end
      end
    end
  end
end
