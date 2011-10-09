require 'spec_helper'

describe Manage::StatsController, :custom do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :custom
  it_ensures_developer_owns_the_game :get, :custom
  
end