module TagsHelper
  def update_tag(tag_name)
    t = Tag.find_by(name: tag_name)
    if t
      t.count += 1
      t.save
    else
      Tag.create!(name: tag_name, count: 1)
    end
  end
end

