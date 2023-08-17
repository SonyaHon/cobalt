PROJECT_FILES := $(wildcard lib/**/*.odin) main.odin

run:
	make cobalt
	./cobalt

cobalt: $(PROJECT_FILES)
	odin build . -o:speed -out:cobalt

cobalt.debug: $(PROJECT_FILES)
	odin build . -debug -out:cobalt.debug