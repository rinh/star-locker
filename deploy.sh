# 部署

IP=$1
ssh_user="pi"
ssh_passwd="raspberry"

if [ -z "$IP" ]; then
    echo "需要正确的派IP"
    exit
fi


# ===========

function upload() {
    from=$1
    to=$2
    tmp="/tmp/t.tmp"

    sshpass -p $ssh_passwd scp -r $1 pi@$IP:$tmp
    sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP "sudo mv $tmp $to"
}

function run() {
    sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP $1
}

# ===========

# 部署项目
run 'mkdir -p /home/pi/server'
upload "./server/locker_services_by_pi.js" "/home/pi/server/locker_services_by_pi.js"
upload "./server/package.json" "/home/pi/server/package.json"
run 'cd /home/pi/server && npm install'

# PM2 安装
run 'sudo npm install -g pm2'

# PM2 管理进程
# 自启动
# https://alili.tech/archive/9b723d04/
# https://github.com/Unitech/pm2/issues/1654
# 
# [PM2] Writing init configuration in /etc/systemd/system/pm2-pi.service
# [PM2] Making script booting at startup...
# [PM2] [-] Executing: systemctl enable pm2-pi...
# [PM2] [v] Command successfully executed.
# +---------------------------------------+
# [PM2] Freeze a process list on reboot via:
# $ pm2 save

# [PM2] Remove init script via:
# $ pm2 unstartup systemd
# run 'pm2 start /home/pi/server/locker_services_by_pi.js'

upload "./SupportFiles/locker_service.sh" "/etc/profile.d/locker_service.sh"
upload "./SupportFiles/rc.local" "/etc/rc.local"


