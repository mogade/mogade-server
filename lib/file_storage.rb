require 'image_science'

class FileStorage
  def self.save_image(filename, stream, previous, generate_thumbnail)
    FileStorage.delete_image(previous) unless previous.nil?
    name = Id.new.to_s + '_' + filename
    buffer = FileStorage.stream_to_buffer(stream)
    FileStorage.save_thumbnail(name, buffer) if generate_thumbnail
    FileStorage.save_to_aws(name, buffer, {'Cache-Control' => 'public,max-age=31536000'})
    name
  end
  
  def self.save_thumbnail(name, buffer)
    ImageScience.with_image_from_memory(buffer.string) do |image|
      image.fit_within(100, 150) do |thumb|
        FileStorage.save_to_aws('thumb' + name, thumb.buffer(File.extname(name)), {'Cache-Control' => 'public,max-age=31536000'})
      end
    end
  end
  
  #can't delete images right away because the profile page is cached
  def self.delete_image(name)
    Store.redis.sadd("cleanup:images:#{Time.now.strftime("%y%m%d")}", name) unless name.nil?
  end
  
  def self.save_asset(file)
    buffer = FileStorage.stream_to_buffer(file.tempfile)
    name = Id.new.to_s + '_' + file.original_filename
    FileStorage.save_to_aws(name, buffer, {'Cache-Control' => 'public,max-age=31536000'}, 'assets')
    name
  end
  
  def self.delete_asset(file)
    return unless file
    path = '/assets/' + file
    AWS::S3::S3Object.delete(path, Settings.aws['bucket'])
  end
  
  def self.replace_asset(existing, file)
    FileStorage.delete_asset(existing)
    FileStorage.save_asset(file)
  end

  private
  def self.save_to_aws(name, buffer, options = {}, folder = nil)
    path = Settings.aws['bucket']
    path += '/' + folder if folder
    AWS::S3::S3Object.store(name, buffer, path, options)
  end
  def self.stream_to_buffer(stream) #solves performance inconsistencies across different servers
    return stream if stream.is_a?(StringIO) 
    #protect us a bit against something odd and bad happening
    #todo make this configurable or something
    return nil if stream.size > 250 * 1024  
    StringIO.new(stream.read.to_s)
  end
end