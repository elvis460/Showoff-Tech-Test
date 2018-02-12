module MainsHelper
  
  def active_first_item(index)
    'active' if index ==0
  end

  def show_instagram_photos(photo)
    case photo['type']
      # show video source
      when "video"
        render 'partial/video_source', soruce: photo
      # show mulitiple images source
      when "carousel"
        render 'partial/carousel_source', source: photo
      # show one image source
      when "image"
        render 'partial/image_source', source: photo
    end
  end
end
