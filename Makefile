.PHONY: trackkeyboard start

install:
	./setup.sh

trackkeyboard:
	./venv/bin/python src/utils/track_keyboard.py

start:
	./venv/bin/python ./src/commands/start.sh