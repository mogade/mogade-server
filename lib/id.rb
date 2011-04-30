module Id
  def self.new
    BSON::ObjectId.new
  end
  def self.valid?(id)
    return false if id.blank? || id.class == Fixnum
    return true if id.class == BSON::ObjectId
    BSON::ObjectId.legal?(id)
  end
  def self.from_string(id)
    return nil unless Id.valid?(id)
    return id if id.class == BSON::ObjectId
    BSON::ObjectId.from_string(id)
  end
end