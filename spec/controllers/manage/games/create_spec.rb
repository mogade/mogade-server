require 'spec_helper'

describe Manage::GamesController, :create do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :post, :create
  
end