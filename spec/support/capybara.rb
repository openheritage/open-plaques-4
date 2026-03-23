# spec/support/capybara.rb
# based on https://www.railsagency.com/blog/2020/03/11/how-to-configure-full-stack-integration-testing-with-selenium-and-ruby-on-rails/
# and https://www.plymouthsoftware.com/articles/rails-on-docker-system-specs-in-containers-with-rspec-capybara-chrome-and-selenium

require 'capybara/rspec'
require 'axe-rspec'

if ENV['SELENIUM_REMOTE_URL']
  Capybara.register_driver :chrome_headless do |app|
    if ENV['SELENIUM_REMOTE_URL']
      capabilities = Selenium::WebDriver::Chrome::Options.new(
        args: %w[no-sandbox headless disable-gpu window-size=1920,1080]
      )
      puts "Capybara::Selenium to talk to #{ENV['SELENIUM_REMOTE_URL']}"
      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        capabilities: [capabilities],
        url: ENV['SELENIUM_REMOTE_URL']
      )
    end
  end
end

module CapybaraMacros
  def click(value)
    6.times do
      if value.include?('#')
        scroll_to(value)
        find(value).click
      else
        click_on(value)
      end
      break
    rescue => e
      puts "nope #{e}"
    end
    wait_for_ajax
  end

  def finished_all_ajax_requests?
    page.evaluate_script('$.active').zero?
  end

  # HACK: to make element visible on page
  def maximize_browser_window
    Capybara.current_session.current_window.resize_to(1000, 1000)
  end

  # https://ricostacruz.com/til/pausing-capybara-selenium
  def pause_selenium
    # not to be confused with Kernel#pause
    $stderr.write 'Press enter to continue'
    $stdin.gets
  end

  def scroll(pixels)
    page.execute_script("window.scrollBy(0,#{pixels})")
  end

  def scroll_to_bottom
    scroll(10_000)
  end

  def scroll_to(element_or_locator)
    script = 'var viewPortHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);' \
             'var elementTop = arguments[0].getBoundingClientRect().top;' \
             'window.scrollBy(0, elementTop-(viewPortHeight/2));'
    element = element_or_locator.is_a?(String) ? find(element_or_locator) : element_or_locator
    page.execute_script(script, element)
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end
end

RSpec.configure do |config|
  config.include CapybaraMacros, type: :system
  config.before(:each, :js, type: :system) do
    if ENV['SELENIUM_REMOTE_URL']
      driven_by :chrome_headless
      Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:3000"
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
      Capybara.server_port = 3000
    else
      driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
    end
  end
end
