# When rake db:seed is run, this run appropriate seed commands from seeds directory. There is different information that needs to be added base on each environment. See /db/seeds/

ActiveRecord::Base.transaction do
  ['common', Rails.env].each do |seedfile|
    seed_file = "#{Rails.root}/db/seeds/#{seedfile}.rb"
    if File.exists?(seed_file)
      puts "- - Seeding data from file: #{seedfile}"
      require seed_file
    end
  end
end
