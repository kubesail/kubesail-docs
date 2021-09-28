# GPIO / LED control

The PiBox has 3 user-controllable LEDs on the front panel that can be controlled via the Pi's GPIO pins using a variety of languages. GPIO pin 16 can be used to turn off all of the system LEDs (the lower 3 LEDs on the front panel)

## Pinout

| GPIO Pin    | Function                           |
| ----------- | ---------------------------------- |
| GPIO 17     | Red LED                            |
| GPIO 27     | Green LED                          |
| GPIO 23     | Blue LED                           |
| ----------- | --------------------               |
| GPIO 16     | Toggle System LEDs (on by default) |

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

    TODO
