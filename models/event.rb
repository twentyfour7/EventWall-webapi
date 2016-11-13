# frozen_string_literal: true
require 'json'
require 'sequel'

# Represents a Event's stored information
class Event < Sequel::Model
  many_to_one :organization
end
