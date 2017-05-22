class Company < ApplicationRecord

  RESERVED_SUBDOMAINS = %w(
    admin api assets blog calendar camo dashboard demo developer developers docs files ftp git imap lab m mail manage mx pages pop sites smtp ssl staging status support www
  )

  validates_exclusion_of :subdomain, :in => RESERVED_SUBDOMAINS,
                         :message => "Subdomain %{value} is reserved."

  # create schema for company
  after_create :create_schema
  # create required defaults for company's application
  after_create :build_application_defaults

  def self.switch(id)
    ActiveRecord::Base.connection.schema_search_path = "company#{id.to_s}, public"
  end

  def self.current
  	Thread.current[:current_company]
  end

  def self.current=(company)
     Thread.current[:current_company] = company
  end

  def create_schema
    self.class.connection.execute("create schema company#{id}")
    scope_schema do
      load Rails.root.join("db/schema.rb")
      self.class.connection.execute("drop table #{self.class.table_name}")
    end
  end

  def build_application_defaults
    scope_schema do
      puts 'Building application defaults. This may take a while.'
      load Rails.root.join("lib/tasks/application_seed.rake")
      Rake::Task['application:seed'].execute subdomain: subdomain
    end
  end

  def scope_schema(*paths)
    original_search_path = self.class.connection.schema_search_path
    self.class.connection.schema_search_path = ["company#{id}", *paths].join(",")
    yield
  ensure
    self.class.connection.schema_search_path = original_search_path
  end

  def scope_time_zone(&block)
    Time.use_zone(time_zone, &block)
  end
end
