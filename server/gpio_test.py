import time
import RPi.GPIO as GPIO

RelayPin = 17    # pin11

def setup():
    GPIO.setmode(GPIO.BCM)       # Numbers GPIOs by physical location
    GPIO.setup(RelayPin, GPIO.OUT)
    # GPIO.output(RelayPin, GPIO.HIGH)

def destroy():
	GPIO.output(RelayPin, GPIO.LOW)
	GPIO.cleanup()     

def loop():
	while True:
		print('relay on')
		GPIO.output(RelayPin, GPIO.HIGH)
		time.sleep(1)
		print('relay off')
		GPIO.output(RelayPin, GPIO.LOW) 
		time.sleep(1)


setup()

if __name__ == '__main__':
	try: 
		loop()
	except KeyboardInterrupt:
		destroy()
