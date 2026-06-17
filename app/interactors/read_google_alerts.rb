class ReadGoogleAlerts
  include Interactor

  def call
    feed = RSS::Parser.parse("https://www.google.com/alerts/feeds/09563737050033496915/15988312346396900564")
    feed.items.each do |item|
      TodoItem.create!(action: "google_alert", description: item.content.content, name: item.title.content, url: item.link.href) unless TodoItem.find_by(action: "google_alert", name: item.title.content)
    end
  end
end