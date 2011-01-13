PWD = '123456'

Factory.define :normal_user, :class => User do |u|
  u.email                 'n@n.com'
  u.first_name            'Normal'
  u.last_name             'User'
  u.cell_phone            '650-342-2343'
  u.home_phone            '650-342-2343'
  u.password              PWD
  u.password_confirmation PWD
end

Factory.define :admin_user, :class => User do |u|
  u.email      'a@a.com'
  u.first_name 'Admin'
  u.last_name  'User'
  u.admin      true
  u.password              PWD
  u.password_confirmation PWD
end

Factory.define :guest_user, :class => User do |u|
  u.email      'g@g.com'
  u.first_name 'Guest'
  u.last_name  'User'
  u.guest      true
  u.password              PWD
  u.password_confirmation PWD
end

Factory.define :developer_user, :class => User do |u|
  u.email      'd@d.com'
  u.first_name 'Developer'
  u.last_name  'User'
  u.developer   true
  u.password              PWD
  u.password_confirmation PWD
end


