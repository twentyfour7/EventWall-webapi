# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      foreign_key :organization_id

      String :title
      String :summary
      String :datetime
      String :location
      String :url, unique: true
      String :cover_img_url
      String :attachment_url
      String :event_type
    end
  end
end
