# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100708214945) do
  create_table 'log_file_mdates', :force => true do |t|
    t.string   :name
    t.datetime :mdate
  end

  create_table 'logs', :force => true do |t|
    t.string   :name
    t.string   :root_path
    t.datetime :created_at
    t.datetime :updated_at
    t.string   :log_path
    t.datetime :mtime
    t.string   :log_type,   :default => "rails2"
  end

  create_table 'users', :force => true do |t|
    t.string   :first_name,                :limit => 100, :default => ""
    t.string   :last_name,                 :limit => 100, :default => ""
    t.string   :email,                     :limit => 100
    t.string   :crypted_password,          :limit => 40
    t.string   :salt,                      :limit => 40
    t.datetime :created_at
    t.datetime :updated_at
    t.string   :remember_token,            :limit => 40
    t.datetime :remember_token_expires_at
  end
  add_index 'users', [:email], :name => 'index_users_on_login', :unique => true
  
  create_table 'roles', :force => true do |t|
    t.references :user
    t.string     :role, :default => 'user'
    t.references :log
    t.timestamps
  end
  add_index 'roles', [:user_id,:log_id], :name => 'index_role_user_id_log_id'
  
  create_table 'hidden_actions', :force => true do |t|
    t.references :user
    t.references :log
    t.string :action_name
    t.string :controller_name
    t.timestamps
  end
end