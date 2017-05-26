# Troubleshooting SMB share creation, share mounting and related issues on Windows

## How it looks

You may see errors during VM start that may look like this:

```
Adding docker SMB share
mount: mounting //192.168.64.1/docksal-c on /c failed: Connection refused
Error creating share
```

```
mount: mounting //192.168.64.1/c on /c failed: Operation now in progress...
exit status 255
```

If you ignored these errors and tried to start a project, then it will probably fail with errors like this:

```
ERROR: for cli  Cannot create container for service cli: error while mounting vo
lume with options: type='none' device='/c/Users/alex/.babun/cygwin/home/
alex/projects/myproject' o='bind': no such file or directory
ERROR: Encountered errors while bringing up the project.
```

## Root cause

During VM start Docksal creates shares for all your local drives `docksal-c` for `C:`,
`docksal-d` for `D:` etc. If Docksal fails to create them for any reason,
then Docker will not be able to access your files.

But even if shares were created successfully, then if mounting those shares from within Docksal VM fails
for any reason, then Docker will not be able to access your files.

## Troubleshooting

### 1. Windows 7 and minimized elevated prompts

Only when Docksal VM is being created, VirtualBox needs to configure network adapter
and requires administrative permissions for that.
Those elevated prompt requests are sometimes appear minimized on the taskbar
and there are warnings about that in console:

```
(docksal) Check network to re-create if needed...
(docksal) Windows might ask for the permission to create a network adapter. Sometimes, such confirmation window is minimized in the taskbar.
(docksal) Found a new host-only adapter: "VirtualBox Host-Only Ethernet Adapter #2"
(docksal) Windows might ask for the permission to configure a network adapter. Sometimes, such confirmation window is minimized in the taskbar.
(docksal) Windows might ask for the permission to configure a dhcp server. Sometimes, such confirmation window is minimized in the taskbar.
```

If you ignored those elevated requests or got distracted and they had timed out,
or you accidentally replied "no", then the adapter will not be created properly and
your only option would be to remove vm with `fin vm remove` and start it again.


### 2. Check it is not your Windows network settings issue

Determine your local IP address. Usually you can do that by running `ipconfig` and
looking for an active adapter that has "Local Area Connection" in the name.

![Getting your IP](_img/troubleshooting-smb-getting-your-ip.png)

Open explorer and navigate to `\\<your.host.ip.address>\`.
It should open with no errors and you should see your network shares.

![Getting your IP](_img/troubleshooting-smb-your-shares.png)

Usually there are some shares, but sometimes you may have none. If there are no shares but
IP opens without any errors, then you should be good with this step.

If you get errors when trying to access IP, then there is an issue with your Windows settings and
you need to fix it. Docksal can not fix it for you, because there are dozens of reasons why it
might fail to work.

The most usual case is "Files and Printer sharing" being not enabled. Enable it in network settings and
try opening that IP again.

If after enabling files sharing you still can not access your IP via explorer,
then see this [elaborate post on superuser about issues with File/Printer sharing on Windows](https://superuser.com/a/446500/140872).
Hopefully it helps. Do not proceed to next steps, if you have not fixed the issue
because they will fail too.

Friendly reminder: if everything fails to make it working, then you might be limited to
re-installing Windows. We test Docksal on clean Windows 7 and Windows 10 installations and
make sure it works.


### 3. Check that Docksal IP is working

**NOTE:** At this step we assume you already did `fin vm start` and that command had failed
with error related to shares or mounting, and you checked out the first step. If your error with vm
start is not related to mounting or shares, then see regular [troubleshooting guide](troubleshooting.md)

Now we need to check Docksal IP. Open explorer and navigate to `\\192.168.64.1\`. This is the IP
that VirtualBox adapter assigns to your host machine. Just like in previous step it should open
with no errors and you should see your network shares (if it opens but you see no shares, then
see next step).

![Getting your IP](_img/troubleshooting-smb-your-shares2.png)

If you get errors when trying to open it, then there is an issue with VirtualBox network adapter. The
most common reason is Windows Firewall blocking it. Try disabling your Firewall and check if it
helps. It disabling firewall helped, then you either need to keep it this way or create an
Incoming rule for your firewall to allow all traffic to all ports from IP `192.168.64.100`.

If you disabled Windows Firewall, but you still can not access this IP address, then it is not
firewall to blame. You would need to refer to the same
[elaborate post on superuser about issues with File/Printer sharing on Windows](https://superuser.com/a/446500/140872).

In worst case try removing Docksal VM with `fin vm rm`, uninstall VirtualBox, **reboot**, install
VirtualBox and start vm with `fin vm start`.

Again, if any option fails you might be limited to re-installing Windows. We had cases when
people that had mysterious share mounting related issues re-installed Windows and everything
worked like a charm.

### 4. Check that drives' shares exist

If both IPs are working, then it's not the network access issue.

Open explorer and navigate to `\\192.168.64.1\`. Make sure that you see and can
access shares, that Docksal should have created for your local drives. `docksal-c`, `docksal-d` etc.

If you see the shares, but can not access them then most likely you hit some edge case. Easiest
fix is to stop Docksal VM, remove those shares manually and start it back again.

If you don't see those shares altogether, then there is an issue with share creation.

Possible common reasons:

* mistyped password
* Microsoft account should use Microsoft account password, not the one that is used to unlock PC
* group policies prevent share creation

Check you password. Check that you can create shares, but do not create Docksal shares manually
unless you know which permissions to set.

Try running `fin vm restart`. If the issue with share creation does not go away and you think
it not password or policies, then see step 6.

### 5. Check your password

Check that you use the correct password. For Microsoft Account use Microsoft Account password
not the one you use to unlock your PC.

**Your password can NOT contain:** `,` (comma), `\` (back slash) or `'` (single quote) symbol
because the password is being passed to the console mount command.

Other special symbols are not an issue but in case your password contains some other special
symbols and you see errors that contain `Invalid argument`:

```
...
Configuring SMB shares...
Enter your Windows account password:
mount: mounting //192.168.64.1/docksal-c on /c failed: Invalid argument
exit status 255
Mount command failed... Trying an alternative method...
mount: mounting //192.168.64.1/docksal-c on /c failed: Invalid argument
exit status 255
```

In this case try simplifying your password and if it works with a new password,
then create an issue on GitHub (see step 6), so we could investigate and fix.

### 6. Report an issue

If you checked all the steps above and it didn't help, then report an
[issue on GitHub](https://github.com/docksal/docksal/issues) and we will investigate the edge case.

If you have questions on resolving issues with steps above try searching the issue queue or
if you stuck, then you can also create an issue on GitHUb to ask a question. Describe which step
you stumbled upon, what fails, what is the error, what did you try to resolve it, provide output
you are getting and `fin sysinfo` output.