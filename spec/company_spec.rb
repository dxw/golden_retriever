# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GoldenRetriever::Company, :vcr do
  describe '#all' do
    subject { described_class.all }

    it 'gets all companies' do
      expect(subject.count).to eq(303)
    end

    it 'returns companies in the right format' do
      expect(subject.first).to be_a(GoldenRetriever::Company)
    end

    it 'returns properties' do
      expect(subject.first.name).to eq('SH24')
    end
  end

  describe '´#find_by_name' do
    let(:company1) { GoldenRetriever::Company.new(name: 'Company 1') }
    let(:company2) { GoldenRetriever::Company.new(name: 'Company 2') }

    before do
      allow(described_class).to receive(:all) { [company1, company2] }
    end

    it 'returns nil if there is no deal' do
      expect(described_class.find_by_name('Some other company')).to eq(nil)
    end

    it 'returns a deal' do
      expect(described_class.find_by_name('Company 1')).to eq(company1)
    end
  end

  describe '#create' do
    let(:name) { 'My Amazing Company' }
    let(:hubspot_company) { described_class.find_by_name(name) }

    before do
      described_class.create(
        name: name
      )

      described_class.instance_variable_set :@all, nil
    end

    it 'creates a company in Hubspot' do
      expect(hubspot_company).to_not be_nil
      expect(hubspot_company.name).to eq(name)
    end
  end
end
