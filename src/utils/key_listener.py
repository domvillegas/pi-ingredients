import os
import threading
from venv import InputDevice, categorize, ecodes

def find_keyboard_device():
    input_by_id = '/dev/input/by-id'
    if not os.path.exists(input_by_id):
        raise FileNotFoundError(f"{input_by_id} does not exist")
    
    for filename in os.listdir(input_by_id):
        if 'kbd' in filename.lower():
            device_path = os.path.join(input_by_id, filename)
            try:
                dev = InputDevice(device_path)
                return device_path
            except Exception:
                continue
    raise RuntimeError("No keyboard device found")

class KeyListener:
    def __init__(self):
        self.device_path = find_keyboard_device()
        self.dev = InputDevice(self.device_path)
        self.callbacks = {}  # keycode -> list of functions
        self.running = False

    def on_key(self, keycode, callback):
        """Register a callback function for a specific keycode."""
        if keycode not in self.callbacks:
            self.callbacks[keycode] = []
        self.callbacks[keycode].append(callback)

    def start(self):
        """Start the listener in a separate thread."""
        if self.running:
            return  # already running
        self.running = True
        thread = threading.Thread(target=self._listen_loop, daemon=True)
        thread.start()

    def stop(self):
        """Stop listening for key presses."""
        self.running = False

    def _listen_loop(self):
        for event in self.dev.read_loop():
            if not self.running:
                break
            if event.type == ecodes.EV_KEY:
                key_event = categorize(event)
                if (
                    key_event.keystate == key_event.key_down
                    and key_event.keycode != 'KEY_NUMLOCK'
                ):
                    callbacks = self.callbacks.get(key_event.keycode, [])
                    for cb in callbacks:
                        cb()  # call registered callbacks

