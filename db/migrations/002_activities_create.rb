# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:activities) do
      # primary_key :org_id
      foreign_key :org_id

      String :datetime
      String :location
      String :description
      String :cover_img
      String :attachment
    end
  end
end
