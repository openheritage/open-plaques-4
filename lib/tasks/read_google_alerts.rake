# frozen_string_literal: true

desc "Read Google Alerts and turn into todo items"
task read_google_alerts: :environment do
  ReadGoogleAlerts.call
end
