# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GoldenRetriever::Deal, :vcr do
  describe '#all' do
    subject { described_class.all }

    it 'gets all deals' do
      expect(subject.count).to eq(852)
    end

    it 'returns deals in the right format' do
      expect(subject.first).to be_a(GoldenRetriever::Deal)
    end

    it 'returns common attributes' do
      expect(subject.first.name).to eq('Mydex reimplementation')
      expect(subject.first.amount).to eq('2200.0')
      expect(subject.first.expected_start_date).to eq(nil)
    end
  end

  describe '#find_by_marketplace_id' do
    let(:deal1) { GoldenRetriever::Deal.new(hs_object_id: 12_345, marketplace_id: 123) }
    let(:deal2) { GoldenRetriever::Deal.new(hs_object_id: 12_345, marketplace_id: 345) }

    before do
      allow(described_class).to receive(:all) { [deal1, deal2] }
    end

    it 'returns nil if there is no deal' do
      expect(described_class.find_by_marketplace_id(789)).to eq(nil)
    end

    it 'returns a deal' do
      expect(described_class.find_by_marketplace_id(123)).to eq(deal1)
    end
  end

  describe '#create' do
    let(:name) { 'My Amazing Deal' }
    let(:marketplace_id) { 1234 }
    let(:opportunity_link) { 'http://example.com' }
    let(:submission_deadline) { Date.parse('2020-01-01') }
    let(:expected_start_date) { Date.parse('2020-02-01') }
    let(:hubspot_deal) { described_class.find_by_marketplace_id(marketplace_id) }
    let(:company) { GoldenRetriever::Company.create(name: 'My Amazing Company') }

    before do
      described_class.create(
        name: name,
        marketplace_id: marketplace_id,
        opportunity_link: opportunity_link,
        submission_deadline: submission_deadline,
        expected_start_date: expected_start_date,
        company_id: company.id
      )

      described_class.instance_variable_set :@all, nil
    end

    it 'creates a deal in Hubspot' do
      expect(hubspot_deal).to_not be_nil
      expect(hubspot_deal.name).to eq(name)
      expect(hubspot_deal.marketplace_id).to eq(marketplace_id.to_s)
      expect(hubspot_deal.opportunity_link).to eq(opportunity_link)
      expect(hubspot_deal.expected_start_date).to eq(expected_start_date)
      expect(hubspot_deal.company_id).to eq(company.id)
    end
  end
end
