# UI Object for console interactions.
@ui = Vagrant::UI::Colored.new

# Install required plugins if not present.
required_plugins = %w(vagrant-triggers)
required_plugins.each do |plugin|
  need_restart = false
  unless Vagrant.has_plugin? plugin
    system "vagrant plugin install #{plugin}"
    need_restart = true
  end
  exec "vagrant #{ARGV.join(' ')}" if need_restart
end

# Determine if we are on Windows host or not.
is_windows = Vagrant::Util::Platform.windows?

# Determine paths.
vagrant_root = File.dirname(__FILE__)  # Vagrantfile location
if is_windows
  vagrant_mount_point = `cygpath #{vagrant_root}`.strip! # Remove trailing \n 
else
  vagrant_mount_point = vagrant_root
end

vagrant_folder_name = File.basename(vagrant_root)  # Folder name only. Used as the SMB share name.

# Use vagrant.yml for local VM configuration overrides.
require 'yaml'
if !File.exist?(vagrant_root + '/vagrant.yml')
  @ui.error 'Configuration file not found! Please copy vagrant.yml.dist to vagrant.yml and try again.'
  exit
end
$vconfig = YAML::load_file(vagrant_root + '/vagrant.yml')

if is_windows
  require 'win32ole'
  # Determine if Vagrant was launched from the elevated command prompt.
  running_as_admin = ((`reg query HKU\\S-1-5-19 2>&1` =~ /ERROR/).nil? && is_windows)
  
  # Run command in an elevated shell.
  def windows_elevated_shell(args)
    command = 'cmd.exe'
    args = "/C #{args} || timeout 10"
    shell = WIN32OLE.new('Shell.Application')
    shell.ShellExecute(command, args, nil, 'runas')
  end

  # Method to create the user and SMB network share on Windows.
  def windows_net_share(share_name, path)
    # Add the vagrant user if it does not exist.
    smb_username = $vconfig['synced_folders']['smb_username']
    smb_password = $vconfig['synced_folders']['smb_password']
    
    command_user = "net user #{smb_username} || net user #{smb_username} #{smb_password} /add"
    @ui.info "Adding vagrant user"
    windows_elevated_shell command_user

    # Add the SMB share if it does not exist.
    command_share = "net share #{share_name} || net share #{share_name}=#{path} /grant:#{smb_username},FULL"
    @ui.info "Adding vagrant SMB share"
    windows_elevated_shell command_share

    # Set folder permissions.
    command_permissions = "icacls #{path} /grant #{smb_username}:(OI)(CI)M"
    @ui.info "Setting folder permissions"
    windows_elevated_shell command_permissions
  end

  # Method to remove the user and SMB network share on Windows.
  def windows_net_share_remove(share_name)
    smb_username = $vconfig['synced_folders']['smb_username']

    command_user = "net user #{smb_username} /delete || echo 'User #{smb_username} does not exist' && timeout 10"
    windows_elevated_shell command_user

    command_share = "net share #{share_name} /delete || echo 'Share #{share_name} does not exist' && timeout 10"
    windows_elevated_shell command_share
  end
else
  # Determine if Vagrant was launched with sudo (as root).
  running_as_root = (Process.uid == 0)
end

# Vagrant should NOT be run as root/admin.
if running_as_root
# || running_as_admin
  @ui.error "Vagrant should be run as a regular user to avoid issues."
  exit
end

######################################################################

# Vagrant Box Configuration #
Vagrant.require_version ">= 1.6.3"

Vagrant.configure("2") do |config|
  config.vm.define "boot2docker"

  config.vm.box = "blinkreaction/boot2docker"
  config.vm.box_version = "1.7.1"
  config.vm.box_check_update = true

  ## Network ##

  # The default box private network IP is 192.168.10.10
  # Configure additional IP addresses in vagrant.yml
  # Using Intel PRO/1000 MT Server [82545EM] network adapter - shows slightly better performance compared to "virtio".
  $vconfig['hosts'].each do |host|
    config.vm.network "private_network", ip: host['ip'], nic_type: "82545EM"
  end unless $vconfig['hosts'].nil?

 ####################################################################
 ## Synced folders configuration ##

  synced_folders = $vconfig['synced_folders']
  # nfs: better performance on Mac
  if synced_folders['type'] == "nfs"  && !is_windows
    config.vm.synced_folder vagrant_root, vagrant_mount_point,
      type: "nfs",
      mount_options: ["nolock", "vers=3", "tcp"]
    config.nfs.map_uid = Process.uid
    config.nfs.map_gid = Process.gid
  # smb: better performance on Windows. Requires Vagrant to be run with admin privileges.
  elsif synced_folders['type'] == "smb" && is_windows
    config.vm.synced_folder vagrant_root, vagrant_mount_point,
      type: "smb",
      smb_username: synced_folders['smb_username'],
      smb_password: synced_folders['smb_password']
  # smb2: experimental, does not require running vagrant as admin.
  elsif synced_folders['type'] == "smb2" && is_windows
    # Create the share before 'up'.
    config.trigger.before :up, :stdout => true, :force => true do
      info 'Setting up SMB user and share'
      windows_net_share vagrant_folder_name, vagrant_root
    end
    
    # Remove the share after 'halt'.
    config.trigger.after :destroy, :stdout => true, :force => true do
      info 'Removing SMB user and share'
      windows_net_share_remove vagrant_folder_name
    end

    # Mount the share in boot2docker.
    config.vm.provision "shell", run: "always" do |s|
      s.inline = <<-SCRIPT
        mkdir -p vagrant $2
        mount -t cifs -o uid=`id -u docker`,gid=`id -g docker`,sec=ntlm,username=$3,pass=$4 //192.168.10.1/$1 $2
      SCRIPT
      s.args = "#{vagrant_folder_name} #{vagrant_mount_point} #{$vconfig['synced_folders']['smb_username']} #{$vconfig['synced_folders']['smb_password']}"
    end  
  # rsync: the best performance, cross-platform platform, one-way only. Run `vagrant rsync-auto` to start auto sync.
  elsif synced_folders['type'] == "rsync"
    # Only sync explicitly listed folders.
    if (synced_folders['folders']).nil?
      @ui.warn "WARNING: 'folders' list cannot be empty when using 'rsync' sync type. Please check your vagrant.yml file."
    else
      for synced_folder in synced_folders['folders'] do
        config.vm.synced_folder "#{vagrant_root}/#{synced_folder}", "#{vagrant_mount_point}/#{synced_folder}",
          type: "rsync",
          rsync__exclude: ".git/",
          rsync__args: ["--verbose", "--archive", "--delete", "-z", "--chmod=ugo=rwX"]
      end
    end
  # vboxfs: reliable, cross-platform and terribly slow performance
  else
    @ui.warn "WARNING: defaulting to the slowest folder sync option (vboxfs)"
      config.vm.synced_folder vagrant_root, vagrant_mount_point,
        mount_options: ["dmode=770", "fmode=660"]
  end

  # Make host SSH keys available to containers on /.ssh
  if File.directory?(File.expand_path("~/.ssh"))
    config.vm.synced_folder "~/.ssh", "/.ssh"
  end

  ######################################################################

  ## VirtualBox VM settings.
  
  config.vm.provider "virtualbox" do |v|
    v.gui = $vconfig['v.gui']  # Set to true for debugging. Will unhide VM's primary console screen.
    v.name = vagrant_folder_name + "_boot2docker"  # VirtualBox VM name.
    v.cpus = $vconfig['v.cpus']  # CPU settings. VirtualBox works much better with a single CPU.
    v.memory = $vconfig['v.memory']  # Memory settings.
    
    # Switch the base box NAT network adapters from "82545EM" to "virtio".
    # Default Intel adapters do not work well with docker...
    # See https://github.com/blinkreaction/boot2docker-vagrant/issues/13 for details.
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]

    # Disable VirtualBox DNS proxy as it may cause issues.
    # See https://github.com/docker/machine/pull/1069
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
    v.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
  end

  ## Provisioning scripts ##

  # Pass vagrant_root variable to the VM and cd into the directory upon login.
  config.vm.provision "shell", run: "always" do |s|
    s.inline = <<-SCRIPT
      echo "export VAGRANT_ROOT=$1" >> /home/docker/.profile
      echo "cd $1" >> /home/docker/.ashrc
    SCRIPT
    s.args = "#{vagrant_mount_point}"
  end
  
  # Install dsh tool (Drude Shell) into VM's permanent storage.
  # https://github.com/blinkreaction/drude
  config.vm.provision "shell" do |s|
    s.inline = <<-SCRIPT
      echo "Installing dsh (Drude Shell)..."
      dsh_script=$(curl -fs https://raw.githubusercontent.com/blinkreaction/drude/develop/bin/dsh)
      if [ ! $? -eq 0 ]; then
        echo -e "dsh download failed..."
      else
        # Download dsh to the permanent storage
        sudo mkdir -p /var/lib/boot2docker/bin
        echo "$dsh_script" | sudo tee /var/lib/boot2docker/bin/dsh >/dev/null
        sudo chmod +x /var/lib/boot2docker/bin/dsh
        sudo ln -sf /var/lib/boot2docker/bin/dsh /usr/local/bin/dsh

        # Making the symlink persistent via bootlocal.sh
        echo '# dsh (Drude Shell)' | sudo tee -a /var/lib/boot2docker/bootlocal.sh > /dev/null
        echo 'sudo ln -sf /var/lib/boot2docker/bin/dsh /usr/local/bin/dsh' | sudo tee -a /var/lib/boot2docker/bootlocal.sh > /dev/null
        sudo chmod +x /var/lib/boot2docker/bootlocal.sh
      fi
    SCRIPT
  end

  # Start system-wide services.
  # Containers must define a "VIRTUAL_HOST" environment variable to be recognized and routed by the vhost-proxy.
  #
  # Wildcard DNS - Mac configuration:
  # $ sudo mkdir /etc/resolver
  # $ echo -e "\n# .drude domain resolution\nnameserver 192.168.10.10" | sudo tee -a  /etc/resolver/drude
  # Check configuration
  # $ scutil --dns
  # $ dig myproject.drude
  #
  if $vconfig['vhost_proxy']
    config.vm.provision "shell", run: "always", privileged: false do |s|
      s.inline = <<-SCRIPT
        echo "Starting system-wide HTTP reverse proxy bound to 192.168.10.10:80... "
        docker rm -f vhost-proxy > /dev/null 2>&1 || true
        docker run -d --name vhost-proxy -p 192.168.10.10:80:80 -p 192.168.10.10:443:443 -v /var/run/docker.sock:/tmp/docker.sock \
        blinkreaction/nginx-proxy@sha256:54b17e5298e6f6c1d442c3070f9c53f6250898da097f59786e4bfef8e77863df > /dev/null

        echo "Starting system-wide DNS service bound to 192.168.10.10:53... "
        docker rm -f dns > /dev/null 2>&1 || true
        docker run -d --name dns -p 192.168.10.10:53:53/udp --cap-add=NET_ADMIN \
        andyshinn/dnsmasq@sha256:86f83680aba9876e9822e5b28774026fce087f45c4cf007783c5a31ff5c9a5dd \
        -A /drude/192.168.10.10 > /dev/null
      SCRIPT
    end
  end

  # Automatically start containers if docker-compose.yml is present in the current directory.
  # See "autostart" property in vagrant.yml.
  if File.file?('./docker-compose.yml') && $vconfig['compose_autostart']
    config.vm.provision "shell", run: "always", privileged: false do |s|
      s.inline = <<-SCRIPT
        echo "Found docker-compose.yml in the root folder. Starting containers..."
        cd $1
        docker-compose up -d
      SCRIPT
      s.args = "#{vagrant_mount_point}"
    end
  end

end
