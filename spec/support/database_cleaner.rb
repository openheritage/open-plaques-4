RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.allow_remote_database_url = true
    # database cleaner truncates all database tables apart from the ones listed for each new set/suite of tests run
    # save time when running tests again by retaining reference data and db/seeds.rb won't recreate them
    DatabaseCleaner.clean_with(:truncation, except: %w[aquifer_designations builds client_sectors critical_drainage_areas developments environment_agencies environment_agency_areas existing_site_vulnerabilities flood_depths flood_zones groundwater_vulnerabilities internal_drainage_boards local_authorities management_catchments purposes regional_flood_and_coastal_committees return_periods river_basin_districts services site_vulnerabilities soils soilscapes source_of_enquiries source_protection_zones superficial_deposits spatial_ref_sys water_companies water_resource_regions water_resource_zones])
    Rails.application.load_seed
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
