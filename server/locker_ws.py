# 先安装 python3 
# https://github.com/instabot-py/instabot.py/wiki/Installing-Python-3.7-on-Raspberry-Pi
# 依赖工具
# pip3 install RPi.GPIO websockets
# https://pgjones.gitlab.io/quart/
# 运行 python3 locker_ws.py

import time
import RPi.GPIO as GPIO

RelayPin = 11    # pin11

def setup():
    GPIO.setmode(GPIO.BOARD)       # Numbers GPIOs by physical location
    GPIO.cleanup()
    GPIO.setup(RelayPin, GPIO.OUT)
    GPIO.output(RelayPin, GPIO.HIGH)

def locker_on():
    GPIO.output(RelayPin, GPIO.HIGH)

def locker_off():
    GPIO.output(RelayPin, GPIO.LOW)
    
def destroy():
	GPIO.output(RelayPin, GPIO.HIGH)
	GPIO.cleanup()     

setup()

# ---------------------


import asyncio
import websockets

async def handler(websocket, path):
    while True:
        async for message in websocket:
            print(message)
            if data == "locker/on":
                locker_on()
            elif data == "locker/off":
                locker_off()

start_server = websockets.serve(hello, "10.0.0.5", 8765)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

