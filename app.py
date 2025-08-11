from src.utils.key_listener import KeyListener
import time

def on_plus():
    print("You pressed +")

def on_esc():
    print("Escape pressed, exiting...")
    listener.stop()

listener = KeyListener()
listener.on_key("KEY_PLUS", on_plus)
listener.on_key("KEY_ESC", on_esc)

listener.start()

print("Listener started. Press keys...")

try:
    while listener.running:
        time.sleep(0.1)
except KeyboardInterrupt:
    listener.stop()
    print("Program terminated by user.")
