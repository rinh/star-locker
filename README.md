# 克隆SD卡

1. 先准备一张母TF卡，需要比目标TF卡的容量要小
2. 使用 EaseUS Partition Master 进行双盘 Clone， 从母TF卡clone到目标TF卡

# 安装新pi

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



# 设定WIFI

1. 拿出tf卡，在根目录创建ssh文件，内容空白即可
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

3. 插回tf卡并开机



# 硬件接驳

![接驳图](http://assets.processon.com/chart_image/6082cb2a0791293ce811ec89.png)




# 连接测试

1. 进入 http://www.easyswoole.com/wstool.html
2. 服务地址：ws://你的树莓派IP:8765

	树莓派IP可以通过路由器里查看

3. `需要发送到服务端的内容`里填写以下内容

	```
	locker_1/off 
	locker_1/on
	```
4. 点击发送，进行测试