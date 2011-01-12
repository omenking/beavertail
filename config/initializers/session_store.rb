# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :expire_after => 365.days,
  :key         => '_beavertail_session',
  :secret      => '7d0d080c1f082a153a528a7b65ce9c960cc3d737c65a7d09171384ed6816ae299d8f7ae00ea631f421fbccd79e43e7f5aec80e380864b3583b43017a3aaee11d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
