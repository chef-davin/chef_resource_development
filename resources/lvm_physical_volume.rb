provides :lvm_physical_volume
unified_mode true

description 'Use the **lvm_physical_volume** resource to manage lvm physical volumes'
introduced '16.3'

property :disk, [String, Array],
  coerce: proc { |d|
    d = if d.is_a?(String)
          Array[d]
        end
    d
  },
  name_property: true,
  description: 'This should point at the physical device(s) for the disk(s) you want to create or resize as a physical volume(s)'

property :wipe_signatures, [true, false],
  default: false,
  description: 'Force the creation of the Logical Volume, even if lvm detects existing PV signatures'

property :ignore_skipped_cluster, [true, false],
  default: false,
  description: 'Continue execution even if lvm detects skipped clustered volume groups'

load_current_value do |desired|
  cmd = <<~CODE
    pvs | grep -v PV | awk '{printf $1","}' | sed 's/,$//'
  CODE
  current_drives = shell_out(cmd).stdout
  current_drives_array = current_drives.split(',')
  puts "\n#{current_drives_array}\n"
  puts "\n#{desired.disk.to_a}\n"
  junction = desired.disk - current_drives_array

  if junction.empty?
    disk desired.disk
  else
    disk current_drives_array
  end
end

action :create do
  converge_if_changed :disk do
    disks = new_resource.disk
    cmd = "echo \"#{disks.join(' ')}\""
    log cmd
    # new_resource.disk.each do |new_disk|
    #   cmd += "pvcreate #{new_disk}"
    #   cmd += "; "
    # end
    shell_out!(cmd)
  end
end
