import os
from evdev import InputDevice

def find_keyboard_device():
    input_by_id = '/dev/input/by-id'
    if not os.path.exists(input_by_id):
        raise FileNotFoundError(f"{input_by_id} does not exist")
    
    for filename in os.listdir(input_by_id):
        if 'kbd' in filename.lower():
            device_path = os.path.join(input_by_id, filename)
            try:
                dev = InputDevice(device_path)
                # Optionally, verify it's actually a keyboard by checking device capabilities
                return device_path
            except Exception:
                continue
    raise RuntimeError("No keyboard device found")

device_path = find_keyboard_device()
print(f"Using keyboard device: {device_path}")