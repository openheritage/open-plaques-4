# creates if does not exist, but does *NOT* update existing
# relationship roles....
Role.find_or_create_by(slug: :son) do |role|
  role.abbreviation = nil
  role.description = "A son is a male offspring; a boy or man in relation to his parents. The female counterpart is a daughter."
  role.index = "s"
  role.name = "son"
  role.prefix = nil
  role.priority = nil
  role.role_type = "child"
  role.suffix = nil
  role.wikidata_id = "Q177232"
end
Role.find_or_create_by(slug: :daughter) do |role|
  role.abbreviation = nil
  role.description = "A daughter is a female offspring; a girl, woman, or female animal in relation to her parents. Daughterhood is the state of being someone's daughter. The male counterpart is a son."
  role.index = "d"
  role.name = "daughter"
  role.prefix = nil
  role.priority = nil
  role.role_type = "child"
  role.suffix = nil
  role.wikidata_id = "Q308194"
end
Role.find_or_create_by(slug: :father) do |role|
  role.abbreviation = nil
  role.description = "A father is the male parent of a child. Besides the paternal bonds of a father to his children, the father may have a parental legal and social relationship with the child that carries with it certain rights and obligations, although this varies between jurisdictions."
  role.index = "f"
  role.name = "father"
  role.prefix = nil
  role.priority = nil
  role.role_type = "parent"
  role.suffix = nil
  role.wikidata_id = "Q7565"
end
Role.find_or_create_by(slug: :mother) do |role|
  role.abbreviation = nil
  role.description = "A mother is the female parent of a child. Mothers are women who inhabit or perform the role of bearing some relation to their children, who may or may not be their biological offspring."
  role.index = "m"
  role.name = "mother"
  role.prefix = nil
  role.priority = nil
  role.role_type = "parent"
  role.suffix = nil
  role.wikidata_id = "Q7560"
end
Role.find_or_create_by(slug: :husband) do |role|
  role.abbreviation = nil
  role.description = "A husband is a male in a marital relationship."
  role.name = "husband"
  role.prefix = nil
  role.priority = nil
  role.role_type = "spouse"
  role.suffix = nil
  role.wikidata_id = "Q212878"
end
Role.find_or_create_by(slug: :wife) do |role|
  role.abbreviation = nil
  role.description = "A wife is a female partner in a continuing marital relationship. A wife may also be referred to as a spouse, which is a gender-neutral term."
  role.index = "w"
  role.name = "wife"
  role.prefix = nil
  role.priority = nil
  role.role_type = "spouse"
  role.suffix = nil
  role.wikidata_id = "Q188830"
end

# some popular roles....
Role.find_or_create_by(slug: :actor) do |role|
  role.abbreviation = nil
  role.description = "An actor is one who portrays a character in a performance. The term is increasingly becoming gender-neutral."
  role.index = "a"
  role.name = "actor"
  role.prefix = nil
  role.priority = nil
  role.role_type = "relationship"
  role.suffix = nil
  role.wikidata_id = "Q33999"
end
Role.find_or_create_by(slug: :architect) do |role|
  role.abbreviation = nil
  role.description = "An architect is someone who plans, designs, and reviews the construction of buildings. To practice architecture means to provide services in connection with the aesthetic design of buildings and the space within the site surrounding the buildings, that have as their principal purpose human occupancy or use. Etymologically, architect derives from the Latin architectus, which derives from the Greek  (arkhi-, chief + tekton, builder), i.e., chief builder. Professionally, an architect's decisions affect public safety, and thus an architect must undergo specialized training consisting of advanced education and a practicum (or internship) for practical experience to earn a license to practice architecture. Practical, technical, and academic requirements for becoming an architect vary by jurisdiction (see below). The terms architect and architecture are also used in the disciplines of landscape architecture, naval architecture and often information technology (for example a network architect or software architect). In most jurisdictions, the professional and commercial uses of the terms \"architect\" and \"landscape architect\" are legally protected."
  role.index = "a"
  role.name = "architect"
  role.prefix = nil
  role.priority = nil
  role.role_type = "person"
  role.suffix = nil
  role.wikidata_id = "Q42973"
end
Role.find_or_create_by(slug: :artist) do |role|
  role.abbreviation = nil
  role.description = "An artist is a person engaged in one or more of any of a broad spectrum of activities related to creating art, practicing the arts or demonstrating an art. The common usage in both everyday speech and academic discourse is a practitioner in the visual arts only. The term is often used in the entertainment business, especially in a business context, for musicians and other performers (less often for actors). \"Artiste\" (the French for artist) is a variant used in English only in this context. Use of the term to describe writers, for example, is valid, but less common, and mostly restricted to contexts like criticism."
  role.index = "a"
  role.name = "artist"
  role.prefix = nil
  role.priority = nil
  role.role_type = "person"
  role.suffix = nil
  role.wikidata_id = "Q483501"
end
Role.find_or_create_by(slug: :author) do |role|
  role.abbreviation = nil
  role.description = "An author is narrowly defined as the originator of any written work and can thus also be described as a writer (with any distinction primarily being an implication that an author is a writer of one or more major works, such as books or plays). More broadly defined, an author is \"the person who originated or gave existence to anything\" and whose authorship determines responsibility for what was created. The more specific phrase published author refers to an author (especially but not necessarily of books) whose work has been independently accepted for publication by a reputable publisher , versus a self-publishing author or an unpublished one ."
  role.index = "a"
  role.name = "author"
  role.prefix = nil
  role.priority = nil
  role.role_type = "person"
  role.suffix = nil
  role.wikidata_id = "Q482980"
end
Role.find_or_create_by(slug: :house) do |role|
  role.abbreviation = "MP"
  role.description = "A house is a building that functions as a home, ranging from simple dwellings such as rudimentary huts of nomadic tribes and the improvised shacks in shantytowns to complex, fixed structures of wood, brick, concrete or other materials containing plumbing, ventilation and electrical systems. Houses use a range of different roofing systems to keep precipitation such as rain from getting into the dwelling space. Houses may have doors or locks to secure the dwelling space and protect its inhabitants and contents from burglars or other trespassers. Most conventional modern houses in Western cultures will contain one or more bedrooms and bathrooms, a kitchen or cooking area, and a living room. A house may have a separate dining room, or the eating area may be integrated into another room. Some large houses in North America have a recreation room. In traditional agriculture-oriented societies, domestic animals such as chickens or larger livestock (like cattle) may share part of the house with humans. The social unit that lives in a house is known as a household. Most commonly, a household is a family unit of some kind, although households may also be other social groups, such as roommates or, in a rooming house, unconnected individuals. Some houses only have a dwelling space for one family or similar-sized group; larger houses called townhouses or row houses may contain numerous family dwellings in the same structure. The design and structure of houses is also subject to change as a consequence of globalization, urbanization and other social, economic, demographic, and technological factors. Various other social and cultural factors also influence the building style and patterns of domestic space. A house may be accompanied by outbuildings, such as a garage for vehicles or a shed for gardening equipment and tools. A house may have a backyard or frontyard, which serve as additional areas where inhabitants can relax or eat."
  role.index = "h"
  role.name = "house"
  role.prefix = nil
  role.priority = nil
  role.role_type = "place"
  role.suffix = nil
  role.wikidata_id = "Q3947"
end
Role.find_or_create_by(slug: :member_of_parliament) do |role|
  role.abbreviation = "MP"
  role.description = nil
  role.index = "m"
  role.name = "Member of Parliament"
  role.prefix = nil
  role.priority = nil
  role.role_type = "person"
  role.suffix = "MP"
  role.wikidata_id = nil
end
Role.find_or_create_by(slug: :novelist) do |role|
  role.abbreviation = nil
  role.description = "A novelist is an author or writer of novels, though often novelists also write in other genres of both fiction and non-fiction. Some novelists are professional novelists, thus make a living writing novels and other fiction, while others aspire to support themselves in this way or write as an avocation. Most novelists struggle to get their debut novel published, but once published they often continue to be published, although very few become literary celebrities, thus gaining prestige or a considerable income from their work. Novelists come from a variety of backgrounds and social classes, and frequently this shapes the content of their works. Public reception of a novelist's work, the literary criticism commenting on it, and the novelists' incorporation of their own experiences into works and characters can lead to the author's personal life and identity being associated with a novel's fictional content. For this reason, the environment within which a novelist works and the reception of their novels by both the public and publishers can be influenced by their demographics or identity; important among these culturally constructed identities are gender, sexual identity, social class, race or ethnicity, nationality, religion, and an association with place. Similarly, some novelists have creative identities derived from their focus on different genres of fiction, such as crime, romance or historical novels. While many novelists compose fiction to satisfy personal desires, novelists and commentators often ascribe a particular social responsibility or role to novel writers. Many authors use such moral imperatives to justify different approaches to novel writing, including activism or different approaches to representing reality \"truthfully\"."
  role.index = "n"
  role.name = "novelist"
  role.prefix = nil
  role.priority = nil
  role.role_type = "person"
  role.suffix = "MP"
  role.wikidata_id = "Q6625963"
end
Role.find_or_create_by(slug: :poet) do |role|
  role.abbreviation = nil
  role.description = "A poet is a person who writes poetry. Poets may describe themselves as such or be described as such by others. A poet may simply be a writer of poetry, or may perform their art to an audience. The work of a poet is essentially one of communication, either expressing ideas in a literal sense, such as writing about a specific event or place, or metaphorically. Poets have existed since antiquity, in nearly all languages, and have produced works that vary greatly in different cultures and time periods. Throughout each civilization and language, poets have used various styles that have changed through the course of literary history, resulting in a history of poets as diverse as the literature they have produced."
  role.index = "p"
  role.name = "poet"
  role.prefix = nil
  role.priority = nil
  role.role_type = "person"
  role.suffix = nil
  role.wikidata_id = "Q49757"
end
Role.find_or_create_by(slug: :writer) do |role|
  role.abbreviation = nil
  role.description = "A writer is a person who uses written words in various styles and techniques to communicate their ideas. Writers produce various forms of literary art and creative writing such as novels, short stories, poetry, plays, screenplays, and essays as well as various reports and news articles that may be of interest to the public. Writers' texts are published across a range of media. Skilled writers who are able to use language to express ideas well often contribute significantly to the cultural content of a society. The word is also used elsewhere in the arts – such as songwriter – but as a standalone term, \"writer\" normally refers to the creation of written language. Some writers work from an oral tradition. Writers can produce material across a number of genres, fictional or non-fictional. Other writers use multiple media – for example, graphics or illustration – to enhance the communication of their ideas. Another recent demand has been created by civil and government readers for the work of non-fictional technical writers, whose skills create understandable, interpretive documents of a practical or scientific nature. Some writers may use images (drawing, painting, graphics) or multimedia to augment their writing. In rare instances, creative writers are able to communicate their ideas via music as well as words. As well as producing their own written works, writers often write on how they write (that is, the process they use); why they write (that is, their motivation); and also comment on the work of other writers (criticism). Writers work professionally or non-professionally, that is, for payment or without payment and may be paid either in advance (or on acceptance), or only after their work is published. Payment is only one of the motivations of writers and many are never paid for their work. The term writer is often used as a synonym of author, although the latter term has a somewhat broader meaning and is used to convey legal responsibility for a piece of writing, even if its composition is anonymous, unknown or collaborative."
  role.index = "w"
  role.name = "writer"
  role.prefix = nil
  role.priority = nil
  role.role_type = "person"
  role.suffix = nil
  role.wikidata_id = "Q36180"
end
# titled roles
Role.find_or_create_by(slug: :knight_bachelor) do |role|
  role.abbreviation = "Kt"
  role.description = "The appointment of Knight Bachelor (Kt) is a part of the British honours system. It is the most basic and lowest rank of a man who has been knighted by the monarch but not as a member of one of the organised Orders of Chivalry. Knights Bachelor are the most ancient sort of British knight (the rank existed during the 13th century reign of King Henry III), but Knights Bachelor rank below knights of the various orders. There is no female counterpart to Knight Bachelor. The lowest knightly honour that can be conferred upon a woman is Dame Commander of the Most Excellent Order of the British Empire (DBE) – which, technically, is one rank higher than Knight Bachelor (being the female equivalent of 'KBE' or Knight Commander of the Most Excellent Order of the British Empire, which is the next male knightly rank above Knight Bachelor). Also, foreigners cannot be created Knights Bachelor; instead they are generally made honorary KBEs."
  role.index = "k"
  role.name = "Knight Bachelor"
  role.prefix = "Sir"
  role.priority = 62
  role.role_type = "title"
  role.suffix = nil
  role.wikidata_id = "Q833163"
end
# membership roles...
Role.find_or_create_by(slug: :band) do |role|
  role.abbreviation = nil
  role.description = nil
  role.index = "b"
  role.name = "band"
  role.prefix = nil
  role.priority = nil
  role.role_type = "group"
  role.suffix = nil
  role.wikidata_id = "Q833163"
end
Role.find_or_create_by(slug: :band_member) do |role|
  role.abbreviation = nil
  role.description = nil
  role.index = "b"
  role.name = "band member"
  role.prefix = nil
  role.priority = nil
  role.role_type = "relationship"
  role.suffix = nil
  role.wikidata_id = nil
end
# letters after your name...
Role.find_or_create_by(slug: :frs) do |role|
  role.abbreviation = "FRS"
  role.description = "Fellowship of the Royal Society (FRS, ForMemRS & HonFRS) is an award and fellowship granted by the Royal Society of London to individuals the society judges to have made a: Fellowship of the Society, the oldest scientific academy in continuous existence, is a significant honour which has been awarded to many eminent scientists from history including Isaac Newton (1672), Charles Darwin (1839), Michael Faraday (1824), Ernest Rutherford (1903), Srinivasa Ramanujan (1919), Albert Einstein (1921), Dorothy Hodgkin (1947), Alan Turing (1951) and Francis Crick (1959). More recently, fellowship has been awarded to Stephen Hawking (1974), Tim Hunt (1991), Elizabeth Blackburn (1992), Tim Berners-Lee (2001), Venkatraman Ramakrishnan (2003), Andre Geim (2007), James Dyson (2015) and around 8000 others in total, including over 280 Nobel Laureates since 1663. As of 2016, there are around 1600 living Fellows, Foreign and Honorary Members. Fellowship of the Royal Society has been described by The Guardian newspaper as “the equivalent of a lifetime achievement Oscar” with several institutions celebrating their announcement each year."
  role.index = "f"
  role.name = "frs"
  role.prefix = nil
  role.priority = 8
  role.role_type = "letters"
  role.suffix = "FRS"
  role.wikidata_id = "Q15631401"
end
Role.find_or_create_by(slug: :vc) do |role|
  role.abbreviation = "VC"
  role.description = "The Victoria Cross (VC) is the highest award of the United Kingdom honours system. It is awarded for gallantry \"in the face of the enemy\" to members of the British armed forces. It may be awarded posthumously. It was previously awarded to Commonwealth countries, most of which have established their own honours systems and no longer recommend British honours. It may be awarded to a person of any military rank in any service and to civilians under military command although no civilian has received the award since 1879. Since the first awards were presented by Queen Victoria in 1857, two thirds of all awards have been personally presented by the British monarch. These investitures are usually held at Buckingham Palace. The VC was introduced on 29 January 1856 by Queen Victoria to honour acts of valour during the Crimean War. Since then, the medal has been awarded 1,358 times to 1,355 individual recipients. Only 15 medals, 11 to members of the British Army, and four to the Australian Army, have been awarded since the Second World War. The traditional explanation of the source of the metal from which the medals are struck is that it derives from Russian cannon captured at the Siege of Sevastopol. Some research has suggested a variety of origins for the material. Research has established that the metal for most of the medals made since December 1914 came from two Chinese cannons that were captured from the Russians in 1855. Owing to its rarity, the VC is highly prized and the medal has fetched over £400,000 at auction. A number of public and private collections are devoted to the Victoria Cross. The private collection of Lord Ashcroft, amassed since 1986, contains over one-tenth of all VCs awarded. Following a 2008 donation to the Imperial War Museum, the Ashcroft collection went on public display alongside the museum's Victoria and George Cross collection in November 2010. Beginning with the Centennial of Confederation in 1967, Canada followed in 1975 by Australia and New Zealand developed their own national honours systems, separate and independent of the British or Imperial honours system. As each country's system evolved, operational gallantry awards were developed with the premier award of each system, the VC for Australia, the Canadian VC and the VC for New Zealand being created and named in honour of the Victoria Cross. These are unique awards of each honours system, recommended, assessed, gazetted and presented by each country."
  role.index = "v"
  role.name = "Victoria Cross recipient"
  role.prefix = nil
  role.priority = 110
  role.role_type = "military medal"
  role.suffix = "VC"
  role.wikidata_id = "Q219578"
end
