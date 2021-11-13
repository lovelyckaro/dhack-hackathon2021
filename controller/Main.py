from machine import Pin, Timer
from utime import sleep_ms
#import network
# Setup networking

# setup as a station

#wlan = network.WLAN(mode=network.WLAN.STA)
#wlan.connect("Basen_24", auth=(network.WLAN.WPA2, 'dumradio'))
#print("Connecting to wifi...")
#while not wlan.isconnected():
#    sleep_ms(50)
#print(wlan.ifconfig())



# Setup callbacks
print("1")
leds = {pin : Pin(pin, mode=Pin.IN, pull=Pin.PULL_DOWN) for pin in ['P3','P4','P5','P6','P7', 'P8']}
buttons = {button : Pin(button, mode=Pin.IN, pull=Pin.PULL_DOWN) for button in ['P9','P10','P11','P12','P19', 'P20']}
vib = Pin('P21', mode=Pin.IN, pull=Pin.PULL_DOWN)
lastButtonPressed = "P9"


#def led_handler(id):
  #leds[id].callback(Pin.IRQ_FALLING | Pin.IRQ_RISING, None)
  #print(id)
  #sleep_ms(1000)
  #leds[id].callback(Pin.IRQ_FALLING | Pin.IRQ_RISING, led_handler, leds[id].id())

def buttonHandler(id):
  if buttons[id].value() == 1: return
  print(id)
  global lastButtonPressed
  global buttonBeforeVib
  buttonBeforeVib = True
  if(id != lastButtonPressed):
    lastButtonPressed = id
    print("button " + id + " pressed")
  
def detectDiff(prev, current):
  diffs = {}
  for led in prev:
    if prev[led] != current[led]:
      diffs[led] = current[led]
  return diffs

recentVib = False
buttonBeforeVib = False

def resetRecentVib(args):
  global recentVib
  recentVib = False
  print("Reset recentvib")
  

def vibHandler(args):
  global recentVib
  global buttonBeforeVib
  if (not recentVib) and buttonBeforeVib:
    print("Jag vibbar som fan här!")
    recentVib = True
    buttonBeforeVib = False
    Timer.Alarm(resetRecentVib, 1, periodic=False)


for button in buttons:
  buttons[button].callback(Pin.IRQ_FALLING, buttonHandler, button)

# print(leds)
prev = {current : leds[current].value() for current in leds}
vib.callback(Pin.IRQ_FALLING, vibHandler)
while True:
  #print("Measuring...")
  measurements = { current : leds[current].value() for current in leds}
  diff = detectDiff(prev, measurements)
  if diff != {}:
    print(diff)
  prev = measurements
  sleep_ms(100)
  
