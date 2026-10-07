require "rails_helper"

RSpec.feature "User adds a plaque.", type: :feature do
  let(:person) { build :person }

  scenario "User searches for a person" do
    fill_in :phrase, with: person.name
    click_button :gosearch
    expect(page).to have_text "Can't find what you're looking for?"
  end

  scenario "User searches for a person then creates a new plaque" do
    fill_in :phrase, with: person.name
    click_button :gosearch
    click_link :goadd
    click_button :commit
    expect(page).to have_text "Thanks for adding this"
  end

  scenario "Spammer tries to inject html in a new plaque" do
    visit "/plaques/new?checked=true"
    fill_in(:plaque_inscription, with: "<a href=\"http://spamtastic.com/youre_hooked\">clik me</a>")
    click_button :commit
    expect(page).to have_text("Latest 20 plaques")
  end
end
