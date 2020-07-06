# Setting up an Ubuntu VM with Vagrant on Windows 10

## Set up an Ubuntu VM

1. Install VirtualBox (https://www.virtualbox.org/wiki/Downloads)
   - Download and install the latest version of VirtualBox **6.0** (as of this writing, [version 6.0.22](https://download.virtualbox.org/virtualbox/6.0.22/VirtualBox-VirtualBox-6.0.22-137980-Win.exe)
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

2. Install Vagrant (https://www.vagrantup.com/downloads.html)
   - Download and install the latest version of Vagrant for Windows (as of this writing, [version 2.2.9](https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.msi)

3. Open a command-line window (cmd.exe)

4. Run the following commands:
   ```
   C:\Users\willis> mkdir c:\files\vagrant\devbox
   C:\Users\willis> cd c:\files\vagrant
   C:\files\vagrant> git clone https://github.com/pwillis-els/vagrant-ubuntu-windows-10.git devbox
   C:\files\vagrant> cd devbox
   C:\files\vagrant\devbox> .\vagrant_up.bat
   ```
Vagrant will now create and provision your new Vagrant box. (this will take some time)

### Troubleshooting
 - If `vagrant_up.bat` fails, edit the file to add ` --debug` after `vagrant up`, to find out more information about the failure.

 - If you get the following error:
   ```
   Stderr: VBoxManage.exe: error: Call to WHvSetupPartition failed: ERROR_SUCCESS (Last=0xc000000d/87) (VERR_NEM_VM_CREATE_FAILED)
   VBoxManage.exe: error: Details: code E_FAIL (0x80004005), component ConsoleWrap, interface IConsole
   ```
   It means VirtualBox is trying to use Hyper-V and failing. You should turn off HyperV and reboot.
   1. Open a new `cmd.exe` console *with Administrator privileges*.
   2. Run the command `bcdedit /set hypervisorlaunchtype off`
   3. Reboot

 - Try opening VirtualBox GUI, going to Preferences, Networking, and make sure there is at least one "NAT" network.

 - If you have networking issues getting your Vagrant box up, try turning off any anti-virus software, or anything else that might mess with your network connection.


## Login to your Vagrant machine
1. To SSH in from the Windows console, just run the `vagrant_ssh.bat` script.
   It will change to the correct directory and run `vagrant ssh` for you.
2. You can also get the ssh connection information with command `vagrant ssh-config`, convert the IdentityFile to a PuTTY .ppk file, and use PuTTY to log in. With PuTTY you can also forward the X11 connection to run graphical apps.


## Create a new SSH key
Vagrant creates an SSH key for you, whose path you can retrieve with the `vagrant ssh-config` command.
However, it is more secure to have a password-protected key that lives only in your Vagrant box.
1. Login to the Vagrant machine (see above)
2. Run the following command and follow the prompts
   ```bash
   $ ssh-keygen -o -t ed25519
   ```

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

