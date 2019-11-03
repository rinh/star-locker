# 初始化一个新的派

# 1
# 需要本机支持 sshpass 
# sshpass -p {密码} scp ${本地主机目录} {用户名}@{主机IP}:${远程主机目录} 
# https://linux.cn/article-8086-1.html
# https://blog.csdn.net/a632189007/article/details/79310897

# 2
# 预先设置好wifi及ssh, 通过参数将树莓派ip传进来
IP=$1
ssh_user="pi"
ssh_passwd="raspberry"

if [ -z "$IP" ]; then
    echo "需要正确的派IP"
    exit
fi

function upload() {
    from=$1
    to=$2
    tmp="/tmp/t.tmp"

    sshpass -p $ssh_passwd scp -r $1 pi@$IP:$tmp
    sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP "sudo mv $tmp $to"
}

sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'echo hello'

# apt-get 源 
upload "./SupportFiles/sources.list" "/etc/apt/sources.list"
upload "./SupportFiles/raspi.list" "/etc/apt/sources.list.d/raspi.list"
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'sudo apt-get update'

# nodejs
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'sudo apt-get install gcc g++ make'
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -'
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list'
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'sudo apt-get update && sudo apt-get install yarn'

# python3.6
upload "./SupportFiles/Berryconda3-2.0.0-Linux-armv7l.sh" "~/Berryconda3-2.0.0-Linux-armv7l.sh"
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'chmod +x ~/Berryconda3-2.0.0-Linux-armv7l.sh'
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP '~/Berryconda3-2.0.0-Linux-armv7l.sh'
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'conda config --add channels rpi'
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'conda install python=3.6'

# pip换源
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'mkdir -p ~/.pip'
upload "./SupportFiles/pip.conf" "~/.pip/pip.conf" 

# vim 
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'sudo apt-get remove vim-common'
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'sudo apt-get install vim -y'
upload "./SupportFiles/vimrc" "/etc/vim/vimrc" 

# ftp
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'sudo apt-get install -y vsftpd'
upload "./SupportFiles/vsftpd.conf" "/etc/vsftpd.conf" 
sshpass -p $ssh_passwd  ssh -o StrictHostKeyChecking=no pi@$IP 'sudo service vsftpd start'








