# GPIO / LED control

The PiBox has a single RGB LED on the front panel (the top unlabeled LED) that is user controllable via 3 separate GPIO using a variety of languages.

<!-- GPIO pin 16 can be used to turn off all of the system LEDs (the lower 3 LEDs on the front panel) -->

## Pinout

| GPIO Pin | Function  |
| -------- | --------- |
| GPIO 17  | Red LED   |
| GPIO 27  | Green LED |
| GPIO 23  | Blue LED  |

<!-- | ----------- | -------------------- | -->
<!-- | GPIO 16     | Toggle System LEDs (on by default) | -->

## Controlling with Bash

The following example turns the Red LED on for 1 second, then off

```bash
# First make the GPIO pin accessible in user space
echo "17" > /sys/class/gpio/export

# Set the GPIO pin as an output
echo "out" > /sys/class/gpio/gpio17/direction

# Turn the LED ON, wait 1 second, then OFF
echo "1" > /sys/class/gpio/gpio17/value
sleep 1
echo "0" > /sys/class/gpio/gpio17/value
```

## Controlling with Python

First, install the `RPi.GPIO` library.

```bash
sudo pip3 install RPi.GPIO
```

The following example toggles the Red channel of the RGB LED once every second, ten times

```python
import RPi.GPIO as GPIO
import time

led = 17

GPIO.setmode(GPIO.BOARD)
GPIO.setup(led, GPIO.OUT)

for i in range(10):
    GPIO.output(led, GPIO.HIGH)
    time.sleep(0.5)
    GPIO.output(led, GPIO.LOW)
    time.sleep(0.5)

GPIO.cleanup()
```
