class Article < ActiveRecord::Base
  attr_accessible :title, :body, :tag_list, :image, :title

  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings

  has_attached_file :image

  def tag_list
    return self.tags.join(", ")
  end

  def tag_list=(tags_string)
    self.taggings.destroy_all

    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq

    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name)
      tagging = self.taggings.new
      tagging.tag_id = tag.id
    end
  end
  
  def self.ordered_by(param)
    case param
    when 'title'      then Article.order('title')
    when 'published'  then Article.order('created_at desc')
    when 'word_count' then Article.order('body desc')
    else              Article.all
    end
  end
end
