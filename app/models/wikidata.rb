require "open-uri"

# A Wikidata object has much information in the open graph
class Wikidata
  DATE_OF_BIRTH = :P569
  DATE_OF_DEATH = :P570
  INSTANCE_OF = :P31
  OCCUPATION = :P106
  SUBCLASS_OF = :P279
  COUNTRY = :P17
  HUMAN = "Q5"
  CAT = "Q146"

  def initialize(qid)
    return unless qid

    raise "expecting a 'Q' code, e.g 'Q81520'" unless qid[/Q\d*$/]

    @qid = qid
    populate
  end

  def born_in
    date_of_birth[/\d\d\d\d/] if date_of_birth
  end

  def date_of_birth
    datetime = @wikidata&.dig(:claims, DATE_OF_BIRTH, 0, :mainsnak, :datavalue, :value, :time)
    # careful of +1600-00-00 for 'unknown month and day' which breaks datetime
    datetime[/\+(\d\d\d\d)-00-00/, 1] || datetime[/\+(\d\d\d\d-\d\d-\d\d)/, 1] if datetime
  end

  def date_of_death
    datetime = @wikidata&.dig(:claims, DATE_OF_DEATH, 0, :mainsnak, :datavalue, :value, :time)
    # careful of +1600-00-00 for 'unknown month and day' which breaks datetime
    datetime[/\+(\d\d\d\d)-00-00/, 1] || datetime[/\+(\d\d\d\d-\d\d-\d\d)/, 1] if datetime
  end

  def dates?(born, died)
    return false if disambiguation_page?

    return false unless (born && born_in) || (died && died_in)

    Rails.logger.debug("for #{title} does (#{born}-#{died}) == (#{born_in}-#{died_in}) ?")
    b_match = born && born_in ? born.to_s == born_in : true
    d_match = died && died_in ? died.to_s == died_in : true
    b_match && d_match
  end

  def description
    @wikidata&.dig(:descriptions, :"en-gb", :value) || @wikidata&.dig(:descriptions, :en, :value)
  end

  def died_in
    date_of_death[/\d\d\d\d/] if date_of_death
  end

  def disambiguation_page?
    @wikidata&.dig(:descriptions, :en, :value)&.include?("disambiguation page")
  end

  def en_wikipedia_url
    link = @wikidata&.dig(:sitelinks, :enwiki, :title)&.gsub(' ', '_')
    "https://en.wikipedia.org/wiki/#{link}"
  end

  def gender

  end

  def human?
    instance_of_qid = @wikidata&.dig(:claims, INSTANCE_OF, 0, :mainsnak, :datavalue, :value, :id)
    instance_of_qid == HUMAN
  end

  def main_image

  end

  def occupation
    @occupation ||= begin
        main_occupation_qid = @wikidata&.dig(:claims, OCCUPATION, 0, :mainsnak, :datavalue, :value, :id)
        occupation_wikidata = Wikidata.new(main_occupation_qid)
        occupation_wikidata.title
      end
  end

  def qcode
    @qid
  end

  def spouse

  end

  def title
    @wikidata&.dig(:labels, :"en-gb", :value) || @wikidata&.dig(:labels, :en, :value)
  end

  private

  def populate
    Rails.logger.debug("** call Wikidata #{@qid} **")
    root = "https://www.wikidata.org/w/api.php"
    api = "#{root}?action=wbgetentities&ids=#{@qid}&format=json"
    response = URI.parse(api).open
    resp = response.read
    resp_json = JSON.parse(resp).deep_symbolize_keys
    @wikidata = resp_json[:entities][@qid.to_sym]
  end
end
