module TagsHelper
  require "net/http"
  require "uri"

  def update_tag(tag_name)
    tag = Tag.find_by(name: tag_name)
    if tag
      tag.count += 1
      tag.save
    else
      Tag.create!(name: tag_name, count: 1)
    end
  end

  def send_top_tag
    uri = URI('https://webhook.site/621a3c9c-0f9f-4dec-b3da-d4b1b5c0f0e0')
    res = Net::HTTP.post_form(uri, Tag.top_tag.name => Tag.top_tag.count)
  end

end

