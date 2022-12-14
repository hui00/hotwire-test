# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  author     :string
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  after_update_commit do
    broadcast_replace_to(
      "post_list",
      target: self,
      partial: "home/posts",
      locals: {
        post: self,
      },
    )
  end
  after_destroy_commit { broadcast_remove_to("post_list", target: self) }
  after_create_commit do
    broadcast_append_to(
      "post_list",
      target: "postbox",
      partial: "home/posts",
      locals: {
        post: self,
      },
    )
  end
end

## https://blog.corsego.com/turbo-hotwire-broadcasts
