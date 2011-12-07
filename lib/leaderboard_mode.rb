module LeaderboardMode
  Normal = 1
  DailyTracksLatest = 2
  AllTrackLatest = 3
  
  def self.nice(value, short = false)
    v = value.is_a?(Integer) ? value : const_get(value)
    case v
      when 1
        short ? 'Nrml' : 'Normal'
      when 2
        short ? 'Daily' : 'Daily Tracks Latest'
      when 3
        short ? 'Ltst' : 'All Track Latest'
    end
  end

  def self.lookup
    local_constants.map{|c| [nice(c), const_get(c)]}
  end
end