module Document
  extend ActiveSupport::Concern
  include EmbeddedDocument
  
  module ClassMethods
    def collection
      Store[self.to_s.tableize]
    end
    def find_by_id(id)
      real_id = Id.from_string(id)
      return nil if real_id.nil?
      
      found = collection.find_one(real_id)
      found.nil? ? nil : self.new(unmap(found))
    end
    def find_one(selector = {})
      found = collection.find_one(map(selector))
      found.nil? ? nil : self.new(unmap(found))
    end
    def find(selector={}, opts={}, collection = nil)
      raw = opts.delete(:raw) || false
      opts[:transformer] = Proc.new{|data| raw ? unmap(data, raw) : self.new(unmap(data)) }
      c = collection || self.collection
      c.find(map(selector), map_options(opts))
    end
    def remove(selector={}, collection = nil)
      c = collection || self.collection
      c.remove(map(selector))
    end
    def count(selector={}, collection = nil)
      c = collection || self.collection
      c.find(map(selector)).count
    end
  end
  module InstanceMethods
    def initialize(attributes = {})
      attributes[:_id] = Id.new unless attributes.include?('_id') || attributes.include?(:_id)
      @attributes = attributes
      attributes.each do |k,v|
        send("#{k}=", v)  unless k == :_id || k == '_id' 
      end
    end
    def eql?(other)
      other.is_a?(self.class) && id == other.id
    end
    alias :== :eql?
    def hash
      id.hash
    end
    def id
      @attributes[:_id] || @attributes['_id']
    end
    def id=(value)
      @attributes[:_id] = value
    end
    def ==(other)
      other.class == self.class && id == other.id
    end
    def collection
      self.class.collection
    end
    def save
      collection.save(self.class.map(@attributes))
    end
    def save!
      collection.save(self.class.map(@attributes), {:safe => true})
    end
  end
end