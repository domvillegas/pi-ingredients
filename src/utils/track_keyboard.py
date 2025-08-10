import os
from evdev import InputDevice, categorize, ecodes

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

def main():
    device_path = find_keyboard_device()
    print(f"Using keyboard device: {device_path}")

    dev = InputDevice(device_path)

    print("Listening for key presses (Ctrl+C to exit)...")

    for event in dev.read_loop():
        if event.type == ecodes.EV_KEY:
            key_event = categorize(event)
            if key_event.keystate == key_event.key_down:
                print(f"Key pressed: {key_event.keycode}")

if __name__ == "__main__":
    main()
