class List < ActiveRecord::Base
  belongs_to :user
  has_many :ideas

  def slug
   self.name.gsub(' ', '-') 
  end

  def self.find_by_slug(slug_name)
    List.all.find { |name| name.slug == slug_name}
  end

  def self.public_lists
  	List.all.select { |list| !list.private? }
  end
end