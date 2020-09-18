# lvm_physical_volume ['/dev/sdb', '/dev/sdc'] do
#   action :create
# end
service 'firewalld' do
  action [:enable, :start]
end
%w(ssh smtp http https).each do |svc|
  firewalld_service svc do
    zone 'public'
    action :add
  end
end

firewalld_service 'https' do
  zone 'drop'
  action :add
end
