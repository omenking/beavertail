u = User.new
u.email = 'admin@localhost.com'
u.password = 'admin'
u.password_confirmation = 'admin'
u.first_name = 'Admin'
u.last_name = 'Localhost'

u.save

u.create_role('admin')

l = Log.create(:name => 'BeaverTail',
  :root_path => "~/Sites/beavertail/",
  :log_path => "~/Sites/beavertail/log/development.log",
  :log_type => 'rails3')

u.add_logs([l.id])