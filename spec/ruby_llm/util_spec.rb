# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyLLM::Util do
  describe '#deep_stringify_keys' do
    it 'transforms keys in hash to strings' do
      expect(described_class.deep_stringify_keys(1 => 2, 3 => { 4 => 5 }, 6 => [7, { 8 => 9}]))
        .to eq('1' => 2, '3' => { '4' => 5 }, '6' => [7, { '8' => 9}])
    end
  end

  describe '#deep_symbolize_keys' do
    it 'transforms keys in hash to strings' do
      expect(described_class.deep_symbolize_keys('a' => 2, 'b' => { 'c' => 5 }, 'd' => [7, { 'e' => 9}]))
        .to eq(a: 2, b: { c: 5 }, d: [7, { e: 9}])
    end
  end

  describe '#deep_transform_keys_in_object' do
    it 'transforms keys in hash and any sub arrays of hashes or sub hashes' do
      expect(described_class.deep_transform_keys_in_object(1 => 2, 3 => { 4 => 5 }, 6 => [7, { 8 => 9}]) { |key| key * 2 })
        .to eq(2 => 2, 6 => { 8 => 5 }, 12 => [7, { 16 => 9}])
    end
  end
end
