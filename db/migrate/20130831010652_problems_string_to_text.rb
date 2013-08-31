class ProblemsStringToText < ActiveRecord::Migration
  def up
  	change_column :problems, :desc, :text, :limit => nil
  	change_column :problems, :methods, :text, :limit => nil 
  	change_column :problems, :variations, :text, :limit => nil 
  end

  def down
  	change_column :problems, :desc, :string  
  	change_column :problems, :methods, :string  
  	change_column :problems, :variations, :string  
  end
end
