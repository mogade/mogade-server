module ScoreDeleterField
  UserName = 1
  Points = 2
  
  def self.nice(value)
    v = value.is_a?(Integer) ? value : const_get(value)
    case v
      when 1
        'UserName'
      when 2
        'Points'
    end
  end

  def self.lookup
    local_constants.map{|c| [nice(c), const_get(c)]}
  end
end