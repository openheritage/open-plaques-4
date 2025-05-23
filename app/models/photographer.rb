# A person who took a photo (and is the copyright holder)
class Photographer
  attr_accessor :id, :photos_count, :rank

  def photos
    Photo.where(photographer: id)
  end

  def plaques
    @plaque_list = []
    photos.each do |photo|
      @plaque_list << photo.plaque if photo.linked?
    end
    @plaque_list
  end

  def self.all
    data = Photo.where.not(plaque_id: nil).group(:photographer).order(count_plaque_id: :desc).distinct.count(:plaque_id)
    @photographers = []
    data.each do |d|
      photographer = Photographer.new
      photographer.id = d[0].to_s.gsub(/\_/, ".")
      photographer.photos_count = d[1]
      @photographers << photographer
    end
    @photographers
  end

  def self.top50
    data = Photo.where.not(plaque_id: nil).group(:photographer).order(count_plaque_id: :desc).distinct.limit(50).count(:plaque_id)
    @photographers = []
    data.each do |d|
      photographer = Photographer.new
      photographer.id = d[0].to_s.gsub('\_', ".").gsub("'", "’").gsub(/\R+/, "")
      photographer.photos_count = d[1]
      photographer.rank = @photographers.size + 1
      @photographers << photographer
    end
    @photographers
  end
end
