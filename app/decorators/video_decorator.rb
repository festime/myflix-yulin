class VideoDecorator
  attr_reader :video

  def initialize(video)
    @video = video
  end

  def display_large_cover
    if video.large_cover_url
      video.large_cover_url
    else
      "http://dummyimage.com/665x375/000000/00a2ff"
    end
  end

  def average_rate
    rates = video.reviews.collect(&:rate)

    if rates.count > 0
      total = 0
      rates.each {|rate| total += rate}
      mean = (total.to_f / rates.count).round(1)
      "#{mean} / 5.0"
    else
      " N/A "
    end
  end
end
