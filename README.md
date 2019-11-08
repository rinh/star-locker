# 安装新pi

## 设定WIFI

1. 拿出sd卡，在根目录创建ssh文件，内容空白即可
2. 在根目录创建 `wpa_supplicant.conf`,内容为

记得wifi使用2.4G

```
country=CN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
  
network={
	ssid="WIFI名称"
	psk="WIFI密码"
	key_mgmt=WPA-PSK
	priority=2
	scan_ssid=1
}
```

3. 插回sd卡

## 部署新环境

1. 将PI接入电源，通过路由器找到该IP地址并记录
2. 在 mac 或 linux 环境下，运行初始化程序

```
sh init.sh [树莓派的IP地址]
```

## 部署应用

1. 将PI接入电源，通过路由器找到该IP地址并记录
2. 在 mac 或 linux 环境下，运行初始化程序

```
sh deploy.sh [树莓派的IP地址]
```


