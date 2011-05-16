module LeaderboardType
  HighToLow = 1
  LowToHigh = 2
  
  def self.nice(value, short = false)
    v = value.is_a?(Integer) ? value : const_get(value)
    case v
      when 1
        short ? 'H2L' : 'High to Low'
      when 2
        short ? 'L2H' : 'Low to High'
    end
  end

  def self.lookup
    local_constants.map{|c| [nice(c), const_get(c)]}
  end
end