module ValueHelper
  def self.to_url(url)
    return url if url.blank? || url.downcase =~ /^https?:\/\//
    'http://' + url
  end
end