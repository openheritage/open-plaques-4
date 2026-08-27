class CrawlRemarkableOhio
  include Interactor

  def call
    agent = Mechanize.new
    page = agent.get("https://remarkableohio.org/")
    linkset = page.search(".//div[@class='county-div' or @class='county-panel']//a")
    county = ""
    united_states = Country.find_by(alpha2: "us")
    features = []
    linkset.each do |link|
      name = link.content
      href = link["href"]
      if href.include?("/county/")
        county = name
        puts "#{county}, OH"
      else
        series_ref = name[/(\d*-\d*) (.*)/, 1]
        name = name[/(\d*-\d*) (.*)/, 2]
        puts "Marker ref #{series_ref}, name: #{name}, in #{county} follow link #{href}"
        detail_page = agent.get(href)
        paragraphs = detail_page.search(".//div[contains(@class, 'elementor-col-66')]//div[@class='elementor-widget-container']")
        inscription = "#{name}. "
        sponsors = ""
        address = ""
        area = nil
        location = ""
        latitude = ""
        longitude = ""
        town = ""
        paragraphs.each_with_index do |paragraph, index|
          inscription += paragraph.to_html[/<b>Side A: <\/b>(.*)<\/div>/, 1].squish if paragraph.to_html.match(/<b>Side A: <\/b>(.*)/)
          if paragraph.to_html.match(/<b>Side B: <\/b>(.*)/) && !paragraph.to_html.match(/<b>Side B: <\/b> Same(.*)/)
            inscription = inscription.gsub(name, name.split(" / ")[0]).squish
            inscription += "#{name.split(" / ")[1]}. " if name.include? " / "
            inscription += paragraph.to_html[/<b>Side B: <\/b>(.*)<\/div>/, 1].squish
          end
          if paragraph.to_html.match(/<b>Sponsors:<\/b> (.*)/)
            raw = paragraph.to_html[/<b>Sponsors:<\/b> (.*)<\/div>/, 1].squish
            sponsors = if raw.split(", ").size == 1 && raw.split(" and ").size == 2
                         raw.split(" and ").map { |name| {name: name} }
                       else
                         raw.gsub(" and ", " ").split(", ").map { |name| {name: name} }
                       end
          end
          if paragraph.to_html.match(/<b>Address:<\/b> (.*)/)
            address = paragraph.to_html[/<b>Address:<\/b> (.*)<\/div>/, 1].squish.chomp(",")
            puts "address: #{address}"
            town = "#{paragraphs[index + 1].content}OH".squish
            puts "town: #{town}"
            area = united_states.areas.find_or_create_by!(name: town)
            puts "area: #{area}"
          end
          location = paragraph.to_html[/<b>Location:<\/b> (.*)<\/div>/, 1].squish if paragraph.to_html.match(/<b>Location:<\/b> (.*)/)
          latitude = paragraph.to_html[/<b>Latitude:<\/b> (.*)<\/div>/, 1].squish if paragraph.to_html.match(/<b>Latitude:<\/b> (.*)/)
          longitude = paragraph.to_html[/<b>Longitude:<\/b> (.*)<\/div>/, 1].squish if paragraph.to_html.match(/<b>Longitude:<\/b> (.*)/)
        end
        feature = { feature: { type: "Feature", geometry: { type: "Point", coordinates: [longitude, latitude] }, properties: [address:, county:, inscription:, location:,  name:, series_ref:, sponsors:, town:] } }
        puts feature
        ohio_historical_marker = Series.find_by(name: "Ohio Historical Marker")
        if Plaque.find_by(series: ohio_historical_marker, series_ref: series_ref)
          Rails.logger.debug("Marker #{series_ref} already exists")
        else
          plaque = Plaque.create!(address:, area:, inscription:, longitude:, latitude:, series: ohio_historical_marker, series_ref:)
          sponsors.each do |sponsor|
            name_without_the = sponsor[:name][/The (.*)/, 1] || sponsor[:name]
            organisation = Organisation.find_or_create_by(name: name_without_the)
            Sponsorship.create!(plaque:, organisation:)
          end
        end
        features << feature
      end
    end
    { type: "FeatureCollection", features: features }
  end
end
