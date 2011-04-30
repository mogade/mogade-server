module Mongo
  class OperationFailure
    def duplicate?
      !(message =~ /duplicate key/).nil?
    end
    def duplicate_on?(field)
      message.include? field
    end
  end
end