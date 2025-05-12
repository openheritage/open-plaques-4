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
pin "masonry-layout" # @4.2.2
pin "desandro-matches-selector" # @2.0.2
pin "ev-emitter" # @1.1.1
pin "fizzy-ui-utils" # @2.0.7
pin "get-size" # @2.0.3
pin "outlayer" # @2.1.1
pin "bootstrap" # @5.3.6
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
