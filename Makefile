.PHONY: build-all build-debug build-release
build-all: build-debug build-release

ROM_NAME := coolgame
ROM_VERSION := 0.0.0
ROM_NAME_DEBUG := $(ROM_NAME)-debug
ROM_NAME_RELEASE := $(ROM_NAME)-$(ROM_VERSION)

DIST_PATH=build/out
OBJ_PATH=build/obj
SOURCE_PATH=source
INCLUDE_PATH=include

SOURCES := \
	header.S \
	char.S \
	data.S \
	vectors.S \
	vectors/irq.S \
	vectors/nmi.S \
	vectors/reset.S \
	main.S

build-debug: $(DIST_PATH)/$(ROM_NAME_DEBUG).nes
build-release: $(DIST_PATH)/$(ROM_NAME_RELEASE).nes

AS := ca65
LD := ld65

ASFLAGS := \
	-I $(INCLUDE_PATH)
ASFLAGS_DEBUG := \
	-g

LDFLAGS := \
	-C linker.ld

LDFLAGS_DEBUG := \
	-m $(DIST_PATH)/$(ROM_NAME_DEBUG).map \
	-Ln $(DIST_PATH)/$(ROM_NAME_DEBUG).labels \
	--dbgfile $(DIST_PATH)/$(ROM_NAME_DEBUG).nes.dbg

OBJECTS := $(addprefix $(OBJ_PATH)/,$(addsuffix .o,$(SOURCES)))

$(OBJ_PATH)/%.S.o: $(SOURCE_PATH)/%.S
	[ -d $(dir $@) ] || mkdir -p $(dir $@)
	$(AS) \
		-o $@ \
		$(ASFLAGS) \
		$(ASFLAGS_DEBUG) \
		$<

$(DIST_PATH)/$(ROM_NAME_DEBUG).nes: linker.ld $(OBJECTS)
	[ -d $(dir $@) ] || mkdir -p $(dir $@)
	$(LD) \
		-o $@ \
		$(LDFLAGS) \
		$(LDFLAGS_DEBUG) \
		$(OBJECTS)

$(DIST_PATH)/$(ROM_NAME_RELEASE).nes: linker.ld $(OBJECTS)
	[ -d $(dir $@) ] || mkdir -p $(dir $@)
	$(LD) \
		-o $@ \
		$(LDFLAGS) \
		$(OBJECTS)

container:
	docker build -t nes-buildbot:latest .
