USER = rpajo

KEYBOARDS = lily58
PATH_lily58 = splitkb/aurora/lily58

all: $(KEYBOARDS)

.PHONY: $(KEYBOARDS)
$(KEYBOARDS):
	# init submodule
	git submodule update --init --recursive
	
	# cleanup old symlinks
	for f in $(KEYBOARDS); do rm -rf $(shell pwd)/qmk_firmware/keyboards/$(PATH_$@)/keymaps/$(USER); done

	# add new symlinks
	ln -s $(shell pwd)/$@ $(shell pwd)/qmk_firmware/keyboards/$(PATH_$@)/keymaps/$(USER)

	# run lint check
	# cd qmk_firmware; qmk lint -km $(USER) -kb $(PATH_$@)

	# run build
	make BUILD_DIR=$(shell pwd) -j1 -C qmk_firmware $(PATH_$@):$(USER) CONVERT_TO=elite_pi

	# cleanup symlinks
	for f in $(KEYBOARDS); do rm -rf ./qmk_firmware/keyboards/$(PATH_$@)/keymaps/$(USER); done

clean:
	rm -rf obj_*
	rm -f *.elf
	rm -f *.map
	rm -f *.hex
	rm -f *.uf2
	rm -f *.tmp