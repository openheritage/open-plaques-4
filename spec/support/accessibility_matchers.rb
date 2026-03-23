RSpec.configure do
  RSpec::Matchers.define :be_accessible do
    match do |actual|
      expect(actual).to be_axe_clean.skipping(:'button-name', :'color-contrast', :'link-in-text-block')
    end
  end
end
