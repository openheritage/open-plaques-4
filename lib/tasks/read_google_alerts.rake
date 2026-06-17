# frozen_string_literal: true

desc 'Read Google Alerts and turn itno todo items'
task read_google_alerts: :environment do
  ReadGoogleAlerts.call
end
