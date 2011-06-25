require 'yaml'
require 'zlib'
 
class ZipIt 
  def initialize(root, jar)
    @root = root
    @jar = jar
  end
  
  def bundle_type(type, folder, extension)
   type.keys.each do |bundle|
     temp_target = "#{@root}/#{folder}/#{bundle}_tmp.#{extension}"
     target = "#{@root}/#{folder}/#{bundle}.#{extension}"
     File.delete temp_target if File.exists? temp_target
     File.delete target if File.exists? target
   
     type[bundle].each do |file|
       source = "#{@root}/#{folder}/#{file}.#{extension}"
       merge(source, temp_target)
     end
     yui(temp_target, target)
     File.delete temp_target
     zip(target, "#{target}.gz")
   end
  end
  
  def zip_images(folder)
    Dir.foreach(folder) do |item|
      next if item == '.' or item == '..'
      path = folder + '/' + item
      if File.directory?(path)
        zip_images(path)        
      else
        zip(path, "#{path}.gz")
      end
    end
  end

  def yui(source, target)
   `java -jar #{@jar} -o #{target} #{source}`
  end

  def zip(source_path, target_path)
   source = File.new(source_path, 'r')
   Zlib::GzipWriter.open(target_path) do |gz|
     while line = source.gets
       gz.puts line
     end
   end
   source.close
  end

  def merge(source_path, target_path)
   source = File.new(source_path, 'r')
   target = File.new(target_path, 'a')
   while line = source.gets
     target.puts line
   end
   target.close
   source.close
  end
end

if ARGV.length == 2
  o = ZipIt.new('', ARGV[0])
  o.yui(ARGV[1], ARGV[1])
  o.zip(ARGV[1], ARGV[1] + '.gz')
else
  root = ARGV[0]
  o = ZipIt.new(root, ARGV[1])
  settings = YAML::load_file(ARGV[2])
  o.bundle_type settings['js'], 'javascripts', 'js'
  o.bundle_type settings['css'], 'stylesheets', 'css'
  o.zip_images root + 'images'
end