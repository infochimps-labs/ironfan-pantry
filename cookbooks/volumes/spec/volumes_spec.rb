# Information about volumes are supplied by ironfan through various roles
# These settings are from a typical setup, and then altered subtly for 
# maximal test coverage

test_volumes = {
  :ephemeral0 => { 
    :attachable =>   "ephemeral",     
    :device            => "/dev/sdb",
    :formattable        => true,
    :fstype             => "ext3",
    :mount_options     => "defaults,noatime",
    :mount_point      => "/mnt",
    :mountable         => true,
    :name              => "ephemeral0",
    :resizable         => true,
    :tags => {   
      :bulk    => true,
      :fallback =>  true,
      :local =>     true,
    },
  },          

  :mongodb => {   
    :attachable =>         "ebs",
    :device =>             "/dev/sdo",
    :formattable =>        true,
    :fstype =>             "xfs",
    :keep =>               true,
    :mount_dump =>         nil,
    :mount_options =>      "defaults,nouuid,noatime",
    :mount_pass =>         nil,
    :mount_point =>        "/data/mongodb",
    :mountable =>          true,
    :name =>               "mongodb",
    :resizable =>          true,
    :size =>               100,
    :tags   => {
      :bulk =>          true,
      :fallback =>      false,
      :local =>         false,
      :mongodb =>       true,
      :mongodb_data =>  true,
      :persistent =>    true,
    },
  },

  :root => {     
    :attachable =>         "ebs",
    :create_at_launch =>   false,
    :device =>             "/dev/sda1",
    :formattable =>        false,
    :fstype =>             "ext4",
    :mount_dump =>         nil,
    :mount_options =>      "defaults,nouuid,noatime",
    :mount_pass =>         nil,
    :mount_point =>        "/",
    :mountable =>          true,
    :name =>               "root",
    :resizable =>          false,
    :tags =>               {},
  },
}

# Information about block devices and file systems are discovered by ohai
block_device = {
  "sda1" => { :removable => 0, :size => 100000 },
  "sdo" => { :removable => 0, :size => 100000 },
  "sdb" => { :removable => 0, :size => 100000 },
}

file_system = {
  "/dev/sda1" => {
    "label" => "Ubuntu",
    "kb_size" => "476460056",
    "kb_used" => "89164172",
    "kb_available" => "363069992",
    "percent_used" => "20%",
    "mount" => "/",
    "fs_type" => "ext4",
    "mount_options" => [
                        "rw",
                        "noatime",
                        "errors=remount-ro"
                       ],
    "uuid" => "9c4c970d-b4fd-4219-bb40-955c2eae5005"
  },
}  

# We have a special case when we are running on top of a xen hypervisor, as the linux
# kernel changes the names of the block devices.
block_device_xen = {
  "xvda1" => { :removable => 0, :size => 100000 },
  "xvdo" => { :removable => 0, :size => 100000 },
  "xvdb" => { :removable => 0, :size => 100000 },
}

file_system_xen = {
  "/dev/xvda1" => {
    "label" => "Ubuntu",
    "kb_size" => "476460056",
    "kb_used" => "89164172",
    "kb_available" => "363069992",
    "percent_used" => "20%",
    "mount" => "/",
    "fs_type" => "ext4",
    "mount_options" => [
                        "rw",
                        "noatime",
                        "errors=remount-ro"
                       ],
    "uuid" => "9c4c970d-b4fd-4219-bb40-955c2eae5005"
  },
}  


file_system_mounted = {
  "/dev/sda1" => {
    "label" => "Ubuntu",
    "kb_size" => "476460056",
    "kb_used" => "89164172",
    "kb_available" => "363069992",
    "percent_used" => "20%",
    "mount" => "/",
    "fs_type" => "ext4",
    "mount_options" => [
                        "rw",
                        "noatime",
                        "errors=remount-ro"
                       ],
    "uuid" => "9c4c970d-b4fd-4219-bb40-955c2eae5005"
  },
  "/dev/sdb" => {
    "label" => "ephemeral0",
    "kb_size" => "476460056",
    "kb_used" => "89164172",
    "kb_available" => "363069992",
    "percent_used" => "20%",
    "mount" => "/mnt",
    "fs_type" => "ext3",
    "mount_options" => [
                        "rw",
                        "noatime",
                        "errors=remount-ro"
                       ],
    "uuid" => "9caadsfasdfasdf"
  },
  "/dev/sdo" => {
    "label" => "mongodb",
    "kb_size" => "476460056",
    "kb_used" => "89164172",
    "kb_available" => "363069992",
    "percent_used" => "20%",
    "mount" => "/data/mongodb",
    "fs_type" => "xfs",
    "mount_options" => [
                        "rw",
                        "noatime",
                        "errors=remount-ro"
                       ],
    "uuid" => "9cafasdfasdfasdf05"
  },
}  


describe 'volumes::format' do
  # In these two scenarios, the root partition is marked as not formatable, so it should not even come up for
  # consideration as a drive to format.

  # The ephemeral drive is marked as formatable, but we set up stub commands to simulate discovering that the
  # drive is already formatted with the appropriate file system
 
  # The mongodb drive is formattable, and should actually be formatted.

  let(:chef_run) do 
    ChefSpec::Runner.new do |node|
      node.set['volumes'] = test_volumes.clone
      node.set['filesystem']= file_system
      node.set['block_device'] = block_device
    end.converge(described_recipe)
  end

  let(:chef_run_xen) do 
    ChefSpec::Runner.new do |node|
      node.set['volumes'] = test_volumes.clone
      node.set['filesystem']= file_system_xen
      node.set['block_device'] = block_device_xen
      node.set[:virtualization] = { :system => "xen" }
    end.converge(described_recipe)
  end

  before do
    stub_command("eval $(blkid -o export /dev/sdo); test $TYPE = 'xfs'").and_return(false)
    stub_command("eval $(blkid -o export /dev/xvdo); test $TYPE = 'xfs'").and_return(false)

    stub_command("eval $(blkid -o export /dev/sdb); test $TYPE = 'ext3'").and_return(true)
    stub_command("eval $(blkid -o export /dev/xvdb); test $TYPE = 'ext3'").and_return(true)
  end

  it "formats file systems" do
    expect(chef_run).to run_execute("/sbin/mkfs -t xfs -f /dev/sdo -L mongodb") 
    expect(chef_run).to_not run_execute("/sbin/mkfs -t ext4 -f /dev/sda1 -L root") 
    expect(chef_run).to_not run_execute("/sbin/mkfs -t ext3 -f /dev/sdb -L ephemeral0") 
  end

  it "formats different file systems on xen" do
    expect(chef_run_xen).to run_execute("/sbin/mkfs -t xfs -f /dev/xvdo -L mongodb") 
    expect(chef_run_xen).to_not run_execute("/sbin/mkfs -t ext4 -f /dev/xvda1 -L root") 
    expect(chef_run_xen).to_not run_execute("/sbin/mkfs -t ext3 -f /dev/xvdb -L ephemeral0") 
  end

  it "persists formatted state of eligible drives on the node object" do
    expect(chef_run.node['volumes']['mongodb']['formatted']).to be_true
    expect(chef_run.node['volumes']['ephemeral0']['formatted']).to be_true
  end

end

describe 'volumes::mount' do
  let(:chef_run) do 
    ChefSpec::Runner.new do |node|
      node.set['volumes'] = test_volumes.clone
      node.set['filesystem']= file_system
      node.set['block_device'] = block_device
    end.converge(described_recipe)
  end

  it "creates mount points" do
    expect(chef_run).to create_directory("/")
    expect(chef_run).to create_directory("/mnt")
    expect(chef_run).to create_directory("/data/mongodb")
  end


  it "mounts file systems" do
    expect(chef_run).to mount_mount("/")
    expect(chef_run).to mount_mount("/mnt")
    expect(chef_run).to mount_mount("/data/mongodb")
  end    
end

describe 'volumes::resize' do
  let(:chef_run) do 
    ChefSpec::Runner.new do |node|
      node.set['volumes'] = test_volumes.clone
      node.set['filesystem']= file_system_mounted
      node.set['block_device'] = block_device
    end.converge(described_recipe)
  end


  it "resizes volumes" do
    # Root partition is marked as non-resizable
    expect(chef_run).to_not run_bash("resize root")
    # epemeral is resizable
    expect(chef_run).to run_bash("resize ephemeral0")
    # mondog is resizable
    expect(chef_run).to run_bash("resize mongodb")
  end

end

describe 'volume cookbook full run' do
  let(:chef_run) do 
    ChefSpec::Runner.new do |node|
      node.set['volumes'] = test_volumes.clone
      node.set['filesystem']= file_system
      node.set['block_device'] = block_device
    end.converge('volumes::default', 'volumes::format', 'volumes::mount', 'volumes::resize')
  end

  before do
    stub_command("eval $(blkid -o export /dev/sdo); test $TYPE = 'xfs'").and_return(false)

    stub_command("eval $(blkid -o export /dev/sdb); test $TYPE = 'ext3'").and_return(true)
  end

  it "formats file systems" do
    expect(chef_run).to run_execute("/sbin/mkfs -t xfs -f /dev/sdo -L mongodb") 
    expect(chef_run).to_not run_execute("/sbin/mkfs -t ext4 -f /dev/sda1 -L root") 
    expect(chef_run).to_not run_execute("/sbin/mkfs -t ext3 -f /dev/sdb -L ephemeral0") 
  end

  it "marks the drive it formated on the node object" do
    expect(chef_run.node['volumes']['mongodb']['formatted']).to be_true
  end

  it "creates mount points" do
    expect(chef_run).to create_directory("/")
    expect(chef_run).to create_directory("/mnt")
    expect(chef_run).to create_directory("/data/mongodb")
  end


  it "mounts file systems" do
    expect(chef_run).to mount_mount("/")
    expect(chef_run).to mount_mount("/mnt")
    expect(chef_run).to mount_mount("/data/mongodb")
  end    

  it "resizes volumes" do
    # Root partition is marked as non-resizable
    expect(chef_run).to_not run_bash("resize root")
    # epemeral is resizable
    expect(chef_run).to run_bash("resize ephemeral0")
    # mondog is resizable
    expect(chef_run).to run_bash("resize mongodb")
  end

end

describe 'volume cookbook second full run' do
  let(:chef_run) do 
    ChefSpec::Runner.new do |node|
      node.set['volumes'] = test_volumes.clone
      node.set['volumes']['ephemeral0']['formatted'] = true
      node.set['volumes']['ephemeral0']['resized'] = true
      node.set['volumes']['mongodb']['formatted'] = true
      node.set['volumes']['mongodb']['resized'] = true
      node.set['filesystem']= file_system
      node.set['block_device'] = block_device
    end.converge('volumes::default', 'volumes::format', 'volumes::mount', 'volumes::resize')
  end


  it "formats no file systems" do
    expect(chef_run).to_not run_execute("/sbin/mkfs -t xfs -f /dev/sdo -L mongodb") 
    expect(chef_run).to_not run_execute("/sbin/mkfs -t ext4 -f /dev/sda1 -L root") 
    expect(chef_run).to_not run_execute("/sbin/mkfs -t ext3 -f /dev/sdb -L ephemeral0") 
  end

  it "creates mount points" do
    expect(chef_run).to create_directory("/")
    expect(chef_run).to create_directory("/mnt")
    expect(chef_run).to create_directory("/data/mongodb")
  end


  it "mounts file systems" do
    expect(chef_run).to mount_mount("/")
    expect(chef_run).to mount_mount("/mnt")
    expect(chef_run).to mount_mount("/data/mongodb")
  end    

  it "resizes no volumes" do
    # Root partition is marked as non-resizable
    expect(chef_run).to_not run_bash("resize root")
    # epemeral is resizable
    expect(chef_run).to_not run_bash("resize ephemeral0")
    # mondog is resizable
    expect(chef_run).to_not run_bash("resize mongodb")
  end

end

