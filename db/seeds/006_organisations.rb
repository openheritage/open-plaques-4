
Organisation.find_or_create_by(slug = :administered_by_english_heritage_as_part_of_the_london_wide_plaque_scheme) do |organisation|
  organisation.description = "Dummy organisation created to encapsulate all plaques which form part of the official London plaque scheme which were erected by the predecessors of English Heritage; the Society of Arts from 1866-1901, the London County Council until 1965, and the Greater London Council until 1986. Plaques erected by other organisations subsequently absorbed into the scheme are included. Plaques which have been removed from the scheme but still exist are excluded."
  organisation.language = nil
  organisation.latitude = 31.7
  organisation.longitude = -99.3
  organisation.name = "administered by English Heritage as part of the London wide plaque scheme"
  organisation.notes = nil
  organisation.website = "https://www.english-heritage.org.uk/visit/blue-plaques/about-blue-plaques/history-of-blue-plaques/"
end
Organisation.find_or_create_by(slug = :english_heritage) do |organisation|
  organisation.description = "The London blue plaques scheme has been run by English Heritage since 1986 and continues to grow at a rate of around 10-15 plaques each year. In their full range, totalling over 800, the capital’s plaques build up a fascinating picture of the varied activities of different ages and the achievements of London’s myriad residents.\r\n\r\nMany of the plaques that EH now maintain were originally issued by London County Council and the Greater London Council and are listed as such on openplaques.org.\r\n \r\nA pilot extension of the blue plaques scheme on a national basis took place in 1998-2005; in these years, plaques were erected in Liverpool & Merseyside, Birmingham, Portsmouth and Southampton."
  organisation.language = nil
  organisation.latitude = 51.51
  organisation.longitude = -0.15
  organisation.name = "English Heritage"
  organisation.notes = "The London blue plaques scheme has been run by English Heritage since 1986, and continues to grow at a rate of around 10-15 plaques each year. In their full range, totalling over 800, the capital’s plaques build up a fascinating picture of the varied activities of different ages and the achievements of London’s myriad residents.\r\n\r\nMany of the plaques that EH now maintains were originally issued by London County Council and the Greater London Council and are listed as such on openplaques.org.\r\n \r\nA pilot extension of the blue plaques scheme on a national basis took place in 1998-2005; in these years, plaques were erected in Liverpool & Merseyside, Birmingham, Portsmouth and Southampton.\r\n\r\nEH lists London plaques at http://www.english-heritage.org.uk/server/show/nav.1499.\r\n"
  organisation.website = nil
end
Organisation.find_or_create_by(slug = :gunter_demnig) do |organisation|
  organisation.description = "Stolperstein is the German word for \"stumbling block\", \"obstacle\", or \"something in the way\". (The plural form of the word is Stolpersteine.) The artist Gunter Demnig has given this word a new meaning, that of a small, cobblestone-sized memorial for a single victim of Nazism. These memorials commemorate individuals – both those who died and survivors – who were consigned by the Nazis to prisons, euthanasia facilities, sterilization clinics, concentration camps, and extermination camps, as well as those who responded to persecution by emigrating or committing suicide. (src: http://en.wikipedia.org/wiki/Stolperstein)"
  organisation.language = nil
  organisation.latitude = 52.53
  organisation.longitude = 13.34
  organisation.name = "Gunter Demnig"
  organisation.notes = nil
  organisation.website = "https://www.stolpersteine.eu/"
end
Organisation.find_or_create_by(slug = :london_county_council) do |organisation|
  organisation.description = "The London County Council succeeded the (Royal) Society of arts as the administrator of the official London commemorative plaque scheme in 1901 and ran it until 1965 when it was abolished and succeeded by the Greater London Council. During this time it erected 268 plaques, 254 of which survive."
  organisation.language = nil
  organisation.latitude = 51.50
  organisation.longitude = -0.14
  organisation.name = "London County Council"
  organisation.notes = "Issued London plaques between 1901 and 1965 when the ruling body of London became the Greater London Council. Reportedly put up greater than 250 plaques."
  organisation.website = nil
end
Organisation.find_or_create_by(slug = :texas_historical_commission) do |organisation|
  organisation.description = nil
  organisation.language = nil
  organisation.latitude = 31.7
  organisation.longitude = -99.3
  organisation.name = "Texas Historical Commission"
  organisation.notes = nil
  organisation.website = nil
end
