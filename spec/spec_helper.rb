require 'rubygems'
require "bundler/setup"

require 'roles'
require 'ammeter/init'

load File.dirname(__FILE__) + "/support/active_record.rb"

def reset_data
  User.destroy_all
  Role.destroy_all
  Forum.destroy_all
  Group.destroy_all
  Privilege.destroy_all
  Customer.destroy_all

  # Users
  User.create(:login => "admin")
  User.create(:login => "moderator")
  User.create(:login => "god")
  User.create(:login => "zombie")

  Customer.create(:login => "admin")
  Customer.create(:login => "moderator")
  Customer.create(:login => "god")
  Customer.create(:login => "zombie")

  # Resources
  Forum.create(:name => "forum 1")
  Forum.create(:name => "forum 2")
  Forum.create(:name => "forum 3")

  Group.create(:name => "group 1")
  Group.create(:name => "group 2")
end
