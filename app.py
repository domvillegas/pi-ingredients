from src.utils.key_listener import KeyListener
import time

def on_esc():
    print("Exiting...")
    listener.stop()

def on_any_key(keycode):
    print(f"Key pressed: {keycode}")

def key_press_handler(keycode):
    on_any_key(keycode)
    if keycode == "KEY_ESC":
        on_esc()


listener = KeyListener()
listener.on_any_key(key_press_handler)

listener.start()

print("Listener started. Press keys...")

try:
    while listener.running:
        time.sleep(0.1)
except KeyboardInterrupt:
    listener.stop()
    print("Program terminated by user.")
