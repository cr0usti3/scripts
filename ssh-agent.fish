#!/usr/bin/fish

if [ $SHLVL -eq 1 ]

/home/seb/.config/fish/functions/convert-ssh-agent.sh > /tmp/export_ssh
. /tmp/export_ssh
cat /tmp/export_ssh
/usr/bin/ssh-add
/usr/bin/touch /tmp/ssh.lock

end



