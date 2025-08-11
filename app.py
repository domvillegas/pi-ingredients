from src.utils.key_listener import KeyListener
import time

def on_plus():
    print("You pressed +")

def on_esc():
    print("Exiting...")
    listener.stop()

def on_any_key(keycode):
    print(f"Key pressed: {keycode}")

def key_press_handler(keycode):
    on_any_key(keycode)
    on_esc()


listener = KeyListener()
listener.on_key("KEY_ESC", lambda: listener.stop())

listener = KeyListener()
listener.on_key("KEY_PLUS", key_press_handler)

listener.start()

print("Listener started. Press keys...")

try:
    while listener.running:
        time.sleep(0.1)
except KeyboardInterrupt:
    listener.stop()
    print("Program terminated by user.")
