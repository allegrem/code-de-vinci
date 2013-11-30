# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_CodeDeVinci_session',
  :secret      => '61e76df0cc7dbbe1d019c1cd0572dda5bb3dbda68526fad54182ed0ba36983c99248f26ff5c12567806f6fe9c9545901f8defe0f9c65d499095989ac5403e61b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
