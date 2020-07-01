# Setting up an Ubuntu VM with Vagrant on Windows 10

## Set up an Ubuntu VM

1. Install VirtualBox (https://www.virtualbox.org/wiki/Downloads)
   - Download and install the latest version of VirtualBox for Windows hosts (as of this writing, [version 6.1.10](https://download.virtualbox.org/virtualbox/6.1.10/VirtualBox-6.1.10-138449-Win.exe)
   - Follow the install and use all the defaults.
   - After install, open the VirtualBox GUI
   - Go to menu *File -> Preferences*
   - In the *General* tab, look for the *Default Machine Folder* setting.
     Set it to `C:\files\VirtualBox VMs`.
     This will avoid your VM being created in your user's home directory, which could cause issues later.
   - Now click *Extensions*.
   - Make sure there is no Oracle VirtualBox Extension Pack listed.  If there is, select it, and click the "X" button to the right to uninstall it.
     The license for this Extension Pack is not free for commercial uses, and you don't need it for a basic headless Linux VM.

2. Install Vagrant 64-bit (https://www.vagrantup.com/downloads.html)
   - Download and install the latest version of Vagrant for Windows (as of this writing, [version 2.2.9](https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.msi)

3. Open a command-line window (cmd.exe)

4. Run the following commands:
   ```
   C:\Users\willis> mkdir c:\files\vagrant\devbox
   C:\Users\willis> cd c:\files\vagrant
   C:\files\vagrant> git clone git@github.com:pwillis-els/vagrant-ubuntu-windows-10.git devbox
   C:\files\vagrant> cd devbox
   C:\files\vagrant\devbox> vagrant up
   ```

## Login to your Vagrant machine
1. To SSH in from the Windows console, open a command-line window (cmd.exe) and run the following:
   ```
   C:\Users\willis> cd c:\files\vagrant\devbox
   C:\files\vagrant\devbox> vagrant ssh
   ```
2. You can also get the ssh connection information with command `vagrant ssh-config`, convert the IdentityFile to a PuTTY .ppk file, and use PuTTY to log in.


## Create a new SSH key
Vagrant creates an SSH key for you, whose path you can retrieve with the `vagrant ssh-config` command.
However, you may find it more secure to have a password-protected key that lives only in your Vagrant box.
1. Login to the Vagrant machine.
2. Run the following command:
   ```bash
   $ ssh-keygen -o -t ed25519
   ```

## Set up GitHub Access
1. Navigate to [Add new SSH key](https://github.com/settings/ssh/new)
2. Put in a title ("Vagrant Devbox") and paste in your SSH public key, which you can get from:
   ```bash
   $ cat ~/.ssh/id_ed25519.pub
   ```
3. Navigate to [Add a New personal access token](https://github.com/settings/tokens/new)
4. Add a description ("Vagrant Devbox") and select the scopes ("repo" is enough to start), and click **Generate Token**
5. Immediately copy down the token on the screen.
6. If your GitHub account is SSO-linked, click **Enable SSO** next to the new Personal Access Token, and then click **Authorize**, and follow the prompts.
7. In your Vagrant box, add your GitHub login credentials to the file `/home/vagrant/.netrc`. Use your new Personal Access Token as the password. (Instructions: https://stackoverflow.com/questions/6031214/git-how-to-use-netrc-file-on-windows-to-save-user-and-password)
8. In your Vagrant box you can now use `git` to checkout GitHub repos using either the HTTPS or SSH protocol.

## Extras

 - Use Docker inside the Vagrant box to run applications, as Ubuntu's versions are not the latest. Examples:
   - Terraform:
     ```bash
     $ mkdir $HOME/bin
     $ printf '#!/bin/bash\ndocker run -i -t hashicorp/terraform:light "$@"\n' > $HOME/bin/dterraform
     $ chmod 755 $HOME/bin/dterraform
     $ ~/bin/dterraform version
     Terraform v0.11.11
     ```

   - AWS CLI:
     ```bash
     $ mkdir $HOME/bin
     $ curl -o $HOME/bin/aws.sh https://raw.githubusercontent.com/mesosphere/aws-cli/master/aws.sh
     $ chmod 755 $HOME/bin/aws.sh
     $ export AWS_ACCESS_KEY_ID="<id>"
     $ export AWS_SECRET_ACCESS_KEY="<key>"
     $ export AWS_DEFAULT_REGION="<region>"
     $ aws.sh s3 ls
     ```
