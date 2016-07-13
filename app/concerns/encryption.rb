require 'active_support/concern'

module Encryption
  extend ActiveSupport::Concern

  def encryption_key
    # if in production. require key to be set.
    if Rails.env.production? || Rails.env.development?
      raise 'Must set encryption token key!!' unless ENV['MPA_ENCRYPTION_KEY']
      ENV['MPA_ENCRYPTION_KEY']
    else
      ENV['MPA_ENCRYPTION_KEY'] ? ENV['MPA_ENCRYPTION_KEY'] : 'test_key'
    end
  end
end
