require 'rails_helper'

RSpec.describe ExternalCollectionsQuery, vcr: { cassette_name: "all_collections" } do
  subject { described_class }
  describe ".all" do
    it "queries plum for all collections" do
      expect(subject.all.map(&:slug)).to eq ["princeton-best", "test-collection-2"]
    end
  end
end
