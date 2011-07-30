class HomeController < ApplicationController
  def index
    @stats = load_stats
  end
  
  private 
  def load_stats
    stats = Rails.cache.read('homecontroller:stats')
    if Rails.env.development? || stats.nil? || (Time.now - stats.dated) > 300
      stats = MogadeStats.load
      Rails.cache.write('homecontroller:stats', stats)
    end
    return stats
  end
end