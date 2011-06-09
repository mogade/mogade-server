class FileStorage
  def self.save_image(filename, stream, previous = nil)
    FileStorage.delete_image(previous) unless previous.nil?
    name = Id.new.to_s + '_' + filename
    AWS::S3::S3Object.store(name, stream, Settings.aws['bucket'], {'Cache-Control' => 'public,max-age=31536000'})
    name
  end
  
  #can't delete images right away because the profile page is cached
  def self.delete_image(name)
    Store.redis.sadd("cleanup:images:#{Time.now.strftime("%y%m%d")}", name) unless name.nil?
  end
end