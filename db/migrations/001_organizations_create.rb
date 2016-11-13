# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:organizations) do
      primary_key :id

      String :name
      String :uri
    end
  end
end
