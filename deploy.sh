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
run 'cd /home/pi/server && yarn install'