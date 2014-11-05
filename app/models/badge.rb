class Badge < ActiveRecord::Base
  attr_accessible :image, :name, :file, :file_name

  has_and_belongs_to_many :students

  before_create :default_name

  mount_uploader :file, FileUploader

  private

    def default_name
      self.name ||= File.basename(file.filename, '.*').gsub("-", " ").gsub("MATHPLUS Badge ", "").split.map(&:capitalize).join(' ')
    end
end
