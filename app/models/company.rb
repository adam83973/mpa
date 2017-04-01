class Company < ApplicationRecord

  after_create :create_schema

  def create_schema
    common_tables = ['users', 'occupations', 'occupation_levels']
    self.class.connection.execute("create schema company#{id}")
    scope_schema do
      load Rails.root.join("db/schema.rb")
      # self.class.connection.execute("drop table #{self.class.table_name}")
      # common_tables.each { |table_name| self.class.connection.execute("drop table #{table_name}") }
    end
  end

  def scope_schema(*paths)
    original_search_path = self.class.connection.schema_search_path
    self.class.connection.schema_search_path = ["company#{id}", *paths].join(",")
    yield
  ensure
    self.class.connection.schema_search_path = original_search_path
  end
end
