class SearchWikidata
  include Interactor

  def call
    if context.term
      term = context.term.tr(
        "’ß#ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
        "'s AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz"
      )
      term.gsub!(/[Ææ]/, "Æ": "AE", "æ": "ae")
      name_and_dates = term.match(/(.*) \((\d\d\d\d)\s*-*\s*(\d\d\d\d)\)/) || term.match(/(.*) \(d.\s*-*\s*(\d\d\d\d)\)/) || term.match(/(.*) \((.*\d\d\d\d).*/)
      if name_and_dates
        name = name_and_dates[1]
        born_in = name_and_dates[2]
        died_in = name_and_dates[3]
      else
        name = term
      end
    else
      name = context.name
      born_in = context.born_in
      died_in = context.died_in
    end
    Rails.logger.debug("name: #{name}, born_in: #{born_in}, died_in: #{died_in}")
    raise "Need at least a term or a name" unless term || name

    search_response = call_search_api(name)

    #  if not_found? try again with first letter in uppercase
    if search_response.dig(:query, :searchinfo, :totalhits) == 0
      search_response = call_search_api(name[0].upcase + name[1..])
    end

    # first page of up to 10 results by default
    search_results = search_response.dig(:query, :search)
    search_results.reject!{ |result| ["Wikimedia category", "Wikimedia disambiguation page", "Wikinews article"].include?(result[:snippet]) || result[:snippet]&.start_with?("scientific article published") }
    context.matches = []
    search_results.each do |result|
      Rails.logger.debug(result)
      w = Wikidata.new(result[:title])
      if w.dates?(born_in, died_in) # direct hit!
        context.direct_hit = w
        break
      end

      context.matches << w
    end
    context.direct_hit = context.matches[0] if context.matches.length == 1
  rescue URI::InvalidURIError
    Rails.logger.error "nasty char in there"
  rescue OpenURI::HTTPError => e
    Rails.logger.error e.message
  end
  
  def call_search_api(name)
    api_root = "https://www.wikidata.org/w/api.php?action=query&list=search&format=json&srsearch="
    api = "#{api_root}#{name}"
    Rails.logger.debug("Wikidata search #{api}")
    response = URI.parse(api).open
    resp = response.read
    JSON.parse(resp).deep_symbolize_keys
  end
end
