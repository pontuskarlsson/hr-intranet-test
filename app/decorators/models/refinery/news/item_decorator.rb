Refinery::News::Item.class_eval do

  def preview_body
    if (m = body.match(/<[a-z]+>(?<content>.+)<\/[a-z]+>/)).present?
      m[:content]
    end
  end

end
