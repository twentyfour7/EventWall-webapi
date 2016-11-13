# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:activities) do
      primary_key :id
      foreign_key :org_id

      String :url
      String :published
      String :title
      String :summary
      String :content
      String :author
    end
  end
end
