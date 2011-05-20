module LeaderboardScope
  Daily = 1
  Weekly = 2
  Overall = 3
  Yesterday = 4
  
  def self.nice(value)
    v = value.is_a?(Integer) ? value : const_get(value)
    case v
      when 1 then 'daily'
      when 2 then 'weekly'
      when 3 then 'overall'
      when 4 then 'yesterday'
    end
  end

  def self.lookup
    local_constants.map{|c| [nice(c), const_get(c)]}
  end
end