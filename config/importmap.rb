# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
# pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "chart.js" # @4.4.9
pin "kurklecolor" # https://cdn.jsdelivr.net/npm/@kurkle/color@0.3.4/+esm
pin "@stimulus-components/chartjs", to: "@stimulus-components--chartjs.js" # @6.0.1
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4
pin_all_from "app/javascript/controllers", under: "controllers"
