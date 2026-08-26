class CrawlRemarkableOhio
  include Interactor

  def call
    agent = Mechanize.new
    page = agent.get("https://remarkableohio.org/")
    linkset = page.search(".//div[@class='county-div' or @class='county-panel']//a")
    linkset.each do |link|
      name = link.content
      href = link["href"]
      if href.include?("county")
        county = name
        puts "#{county}, OH"
      else
        marker_ref = name[/(\d*-\d*) (.*)/, 1]
        puts "Marker ref #{marker_ref}, name: #{name}, in #{county} follow link #{href}"
      end
    end
  end
end
