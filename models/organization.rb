# frozen_string_literal: true
require 'json'
require 'sequel'

# Represents a Organization's stored information
class Organization < Sequel::Model
  one_to_many :events
end
