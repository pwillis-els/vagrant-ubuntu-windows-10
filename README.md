Setting up an Ubuntu VM with Vagrant on Windows 10
=================

## Set up an Ubuntu VM

### 1. Install VirtualBox
 - Download and install the latest version of VirtualBox **6.0** (as of this writing, [version 6.0.22](https://download.virtualbox.org/virtualbox/6.0.22/VirtualBox-VirtualBox-6.0.22-137980-Win.exe))
   - **Do not use VirtualBox 6.1.** It causes networking issues, and it requires Intel VT-x/AMD-v to be enabled. Even if VT-x is enabled, if Hyper-v is also enabled, VirtualBox will not be able to use it. (https://forums.virtualbox.org/viewtopic.php?f=1&t=62339 https://github.com/kubernetes/minikube/issues/4587)
 - Follow the install and use all the defaults.
 - After install, open the VirtualBox GUI
 - Go to menu *File -> Preferences*
 - In the *General* tab, look for the *Default Machine Folder* setting.
   Set it to `C:\files\VirtualBox VMs`.
   This will avoid your VM being created in your user's home directory, which could cause issues later.
 - Now click *Extensions*.
 - Make sure there is no Oracle VirtualBox Extension Pack listed.  If there is, select it, and click the "X" button to the right to uninstall it.
   The license for this Extension Pack is not free for commercial uses, and you don't need it for a basic headless Linux VM.

### 2. Install Vagrant
 - Download and install the latest version of Vagrant for Windows (as of this writing, [version 2.2.9](https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.msi))

### 3. (optional) Install Git for Windows
 - Download at https://gitforwindows.org/
 - This is only used to download the files in this Git repo.
   You can skip this step if you download each file in this repo and put them in the `devbox` folder shown in the next step.
   However, using Git will allow you to `git pull` any updates to this repo in the future.

### 4. Create the Vagrant box
 - Open a command-line window (`cmd.exe`) and run the following commands:
   ```
   C:\Users\willis> mkdir c:\files\vagrant\devbox
   C:\Users\willis> cd c:\files\vagrant
   C:\files\vagrant> git clone https://github.com/pwillis-els/vagrant-ubuntu-windows-10.git devbox
   C:\files\vagrant> cd devbox
   C:\files\vagrant\devbox> .\vagrant_up.bat
   ```
   The `vagrant_up.bat` file sets the location of your *VAGRANT_HOME* directory to `C:\files\vagrant`. Otherwise it would be created in your user's profile directory, which could cause problems later. If you're going to run more `vagrant` commands, first set the variable in your console as shown in `vagrant_up.bat`.

Vagrant will now create and provision your new Vagrant box. (this will take some time)

### Troubleshooting
 - If `vagrant_up.bat` fails:
   1. Edit the file to add ` --debug` after `vagrant up`
   2. Run `vagrant_up.bat` again, which should provide more information about why it failed.

 - If you get the following error:
   ```
   Stderr: VBoxManage.exe: error: Call to WHvSetupPartition failed: ERROR_SUCCESS (Last=0xc000000d/87) (VERR_NEM_VM_CREATE_FAILED)
   VBoxManage.exe: error: Details: code E_FAIL (0x80004005), component ConsoleWrap, interface IConsole
   ```
   It may mean VirtualBox is trying to use Hyper-V and failing. You should turn off HyperV and reboot.
   1. Open a new `cmd.exe` console *with Administrator privileges*.
   2. Run the command `bcdedit /set hypervisorlaunchtype off`
   3. Reboot
   
 - Try opening the *Oracle VM VirtualBox* Windows app, going to Preferences -> Networking, and make sure there is at least one "NAT" network.

 - If you have networking issues getting your Vagrant box up, try turning off any anti-virus software, or anything else that might mess with your network connection.
 
 - If you get a warning about the *VirtualBox Guest Additions* being out of date, use the following guide to update your guest's Guest Additions: https://linuxize.com/post/how-to-install-virtualbox-guest-additions-in-ubuntu/ (note: you may need to first add a CDROM device to one of the existing storage devices)


## Login to your Vagrant machine

To SSH in from the Windows console, just run the `vagrant_ssh.bat` script. It will change to the correct directory and run `vagrant ssh` for you.

You can also get the ssh connection information with command `vagrant ssh-config`, convert the IdentityFile to a PuTTY .ppk file, and use this file as the private key to log in to the Vagrant machine.

With PuTTY you can also forward the X11 connection, which when combined with a windows X11 server, enables you to run graphical apps and display them natively in Windows.

### Use a new SSH key to connect to the Vagrant guest

Vagrant automatically creates an SSH key for you to connect to your Vagrant guest.
You can get the path to this IdentityFile with the `vagrant ssh-config` command.
However, it is more secure to have your own password-protected key.

#### 1. Create a new key if you don't already have one

If you don't already have an SSH key to use, you can generate one with the `PuTTYgen.exe` program.
You can also run the command `ssh-keygen -o -t ed25519` on the Vagrant machine itself, which will create a new SSH private and public key.

You will need to copy the private key (`/home/vagrant/.ssh/id_ed25519`) to your host machine for your SSH client to use.
If you are using PuTTY, you will need to convert this key into a PuTTY `.ppk` file, using the `PuTTYgen.exe` program.

#### 2. Add the new public key to the Vagrant user's authorized_keys

Login to the Vagrant machine.
There should be a file `/home/vagrant/.ssh/authorized_keys`, which Vagrant creates to allow its default SSH key to login to this machine.

Open up this file with a console text editor (`vi`, `nano`, etc), remove the existing line, and replace it with your own SSH public key.
Now you can only login with the SSH key that you have created.

#### 3. Replacing the Vagrant SSH key with your own

Vagrant may try to use the SSH connection to do some work on the guest, such as guest provisioning.
Therefore you may need to replace the IdentityFile that Vagrant has configured with your newly-created one.

Just run `vagrant ssh-config` (see above) and copy your SSH private key over the file listed.
If your SSH private key is a PuTTY `.ppk` file, you'll need to convert it into PEM format first (using `PuTTYgen.exe`).

### Troubleshooting
 - Sometimes the SSH settings may change, like the port on your local host that is forwarded to the guest SSH port. From a Windows command-line, run the following commands:
   ```
   C:\Users\willis> SETLOCAL
   C:\Users\willis> SET VAGRANT_HOME=C:\files\vagrant
   C:\Users\willis> PUSHD C:\files\vagrant\devbox
   C:\files\vagrant\devbox>vagrant ssh-config
   ```
   
   Verify that the HostName, User, and Port options in your SSH client match what is on the screen.
   
   If you still have trouble logging in with PuTTY, you may need to convert the IdentityFile to a PuTTY .ppk file again in case the file changed.




## Set up GitHub Access
1. Navigate to [Add new SSH key](https://github.com/settings/ssh/new)
2. Put in a title ("Vagrant Devbox") and paste in your SSH public key, which you can get from your Vagrant box:
   ```bash
   $ cat ~/.ssh/id_ed25519.pub
   ```
3. Navigate to [Add a New personal access token](https://github.com/settings/tokens/new)
4. Add a description ("Vagrant Devbox") and select the scopes ("repo" is enough to start), and click **Generate Token**
5. Immediately copy down the token on the screen.
6. If your GitHub account is SSO-linked, click **Enable SSO** next to the new Personal Access Token, and then click **Authorize**, and follow the prompts.
7. In your Vagrant box, add your GitHub login credentials to the file `/home/vagrant/.netrc`. Use your new Personal Access Token as the password. (Instructions: https://stackoverflow.com/questions/6031214/git-how-to-use-netrc-file-on-windows-to-save-user-and-password)
8. In your Vagrant box you can now use `git` to clone GitHub repos using either the HTTPS or SSH protocol.

## Extras

 - Use Docker inside the Vagrant box to run applications, as Ubuntu's versions are not the latest. Examples:
   - Terraform:
     ```bash
     $ mkdir $HOME/bin
     $ printf '#!/bin/bash\ndocker run -i -t hashicorp/terraform:light "$@"\n' > $HOME/bin/dterraform
     $ chmod 755 $HOME/bin/dterraform
     $ ~/bin/dterraform version
     Terraform v0.12.28
     ```

   - AWS CLI:
     ```bash
     $ mkdir $HOME/bin
     $ curl -o $HOME/bin/aws.sh https://raw.githubusercontent.com/mesosphere/aws-cli/master/aws.sh
     $ chmod 755 $HOME/bin/aws.sh
     $ export AWS_ACCESS_KEY_ID="<id>"
     $ export AWS_SECRET_ACCESS_KEY="<key>"
     $ export AWS_DEFAULT_REGION="<region>"
     $ ~/bin/aws.sh s3 ls
     ```

[1]: https://askubuntu.com/questions/41605/trouble-downloading-packages-list-due-to-a-hash-sum-mismatch-error/
