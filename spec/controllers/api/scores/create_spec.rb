require 'spec_helper'

describe Api::ScoresController, :create do
  extend ApiHelper
  
  setup
  it_ensures_a_valid_context :post, :create
  it_ensures_a_signed_request :post, :create
  it_ensures_a_valid_leaderboard :post, :create, Proc.new { {:username => 'leto', :userkey => 'one'} }
  it_ensures_a_valid_player :post, :create
end