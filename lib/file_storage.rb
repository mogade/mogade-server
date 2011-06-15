require 'image_science'

class FileStorage
  def self.save_image(filename, stream, previous, generate_thumbnail)
    FileStorage.delete_image(previous) unless previous.nil?
    name = Id.new.to_s + '_' + filename
    FileStorage.save_thumbnail(name, stream) if generate_thumbnail
    FileStorage.save_to_aws(name, stream, {'Cache-Control' => 'public,max-age=31536000'})
    name
  end
  
  def self.save_thumbnail(name, stream)
    ImageScience.with_image_from_memory(stream.read) do |image|
      image.fit_within(100, 150) do |thumb|
        FileStorage.save_to_aws('thumb' + name, thumb.buffer(File.extname(name)), {'Cache-Control' => 'public,max-age=31536000'})
      end
    end
  end
  
  #can't delete images right away because the profile page is cached
  def self.delete_image(name)
    Store.redis.sadd("cleanup:images:#{Time.now.strftime("%y%m%d")}", name) unless name.nil?
  end
  
  private
  def self.save_to_aws(name, data, options = {})
    AWS::S3::S3Object.store(name, data, Settings.aws['bucket'], options)
  end
end