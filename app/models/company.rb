class Company < ApplicationRecord

  RESERVED_SUBDOMAINS = %w(
    admin api assets blog calendar camo dashboard demo developer developers docs files ftp git imap lab m mail manage mx pages pop sites smtp ssl staging status support www
  )

  validates_exclusion_of :subdomain, :in => RESERVED_SUBDOMAINS,
                         :message => "Subdomain %{value} is reserved."

  # create schema for company
  after_create :create_schema

  def create_schema
    common_tables = ['users', 'occupations', 'occupation_levels']
    self.class.connection.execute("create schema company#{id}")
    scope_schema do
      load Rails.root.join("db/schema.rb")
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
