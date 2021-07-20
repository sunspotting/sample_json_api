class Tag < ApplicationRecord
  def self.top_tag
    Tag.all.sort_by(&:count).last
  end
end
