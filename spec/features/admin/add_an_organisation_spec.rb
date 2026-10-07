require "rails_helper"

RSpec.feature "Admin adds an organisation.", type: :feature do
  let(:admin) { create(:user) }
  let(:organisation) { build :organisation }

  before do
    login_as(admin, scope: :user)
    visit "/"
  end

  scenario "click add on the org page" do
    click_nav "Organisations"
    click_on "add"
    fill_in :organisation_name, with: organisation.name
    click_button :commit
    expect(page).to have_text "Thanks for adding this"
  end
end
