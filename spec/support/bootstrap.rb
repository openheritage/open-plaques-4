module Features
  module Bootstrap
    def click_nav(value)
      within('#navbar') { click_on(value) }
    end

    def click_wizard(value)
      click("a#wizard_#{value}")
      wait_for = "##{value}_step"
      i = 0
      max_tries = 10
      while value != :project && i < max_tries
        begin
          find(wait_for)
          puts("found #{wait_for}")
          i = max_tries
        rescue
          puts("#{wait_for} not loaded yet (attempt #{i})")
          i += 1
        end
      end
    end

    def click_vertical_nav(value)
      wait_for_ajax
      within('#navbar-vertical') do
        link = find_by_id('nav-link', text: value)
        link.hover
        click(link)
      end
    end

    def have_main_heading(value)
      have_css('h1', text: value)
    end

    def have_sub_heading(value)
      have_css('h2', text: value)
    end

    def submit
      find('input[name="commit"]').click
      wait_for_ajax
    end

    def form(model)
      xpath = ".//form[@action='/#{model.name.pluralize.underscore}']"
      find(:xpath, xpath)
    end
  end
end

RSpec.configure do |config|
  config.include Features::Bootstrap, type: :system
end
