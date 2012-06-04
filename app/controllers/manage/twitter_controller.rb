class Manage::TwitterController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
  end
end