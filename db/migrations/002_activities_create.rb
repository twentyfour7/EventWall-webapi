# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:activities) do
      primary_key :id
      foreign_key :organization_id

      String :api_id
      String :datetime
      String :description
      String :cover_img
      String :attachment
    end
  end
end
