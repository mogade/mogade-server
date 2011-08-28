class Api::Gamma::AssetsController < Api::Gamma::ApiController
  before_filter :ensure_context
  
  def index
    payload = Asset.find_for_game(@game, true)
      .sort{|a,b| b[:dated] <=> a[:dated]}
      .each{|a| a[:file] = 'http://' + Settings.aws_root_path + 'assets/' + a[:file] if a[:file]}
    render_payload(payload, params, 180, 180)
  end

end