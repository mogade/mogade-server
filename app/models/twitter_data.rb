class TwitterData
  include MongoLight::EmbeddedDocument
  mongo_accessor({:interval => :i, :messages => :m})
end