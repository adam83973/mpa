desc "Cache subdomain values across all uploaded objects by company."
task cache_subdomains: :environment do
  cache_subdomain_values
end

def cache_subdomain_values
  # add subdomain values to uploaded objects for each schema (company) Uploaded objects include: badges, experiences, occupation levels, resources, avatars. Adding the subdomain allows us to scope the directories in S3 to and individual company.

  companies = Company.all

  companies. each do |company|
    company.scope_schema do
      # resources
      resources = Resource.all
      resources.each{ |resource| resource.update_attribute :subdomain, company.subdomain  }
      # badges
      badges = Badge.all
      badges.each{ |badge| badge.update_attribute :subdomain, company.subdomain  }
      # experiences
      experiences = Experience.all
      experiences.each{ |experience| experience.update_attribute :subdomain, company.subdomain  }
      # occupation levels
      occupation_levels = OccupationLevel.all
      occupation_levels.each{ |occupation_level| occupation_level.update_attribute :subdomain, company.subdomain  }
      # avatars
      avatars = Avatar.all
      avatars.each{ |avatar| avatar.update_attribute :subdomain, company.subdomain }
    end
  end
end
