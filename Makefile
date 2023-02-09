rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

CPPSourceCode = $(call rwildcard,Source,*.cpp)
Objects = $(patsubst Source/%.cpp, Build/%.o, $(CPPSourceCode))
Directories = $(wildcard Source/*)

Build/%.o: Source/%.cpp
	@-mkdir -p $(@D)
	@-x86_64-w64-mingw32-g++ -Werror -m64 -maccumulate-outgoing-args -ffreestanding -c $^ -o $@

all: $(Objects)
	@-mkdir -p ../Build/ISO/EFI/BOOT/
	@x86_64-w64-mingw32-g++ $(Objects) -Werror -m64 -nostdlib -shared -Wl,-dll -Wl,--subsystem,10 -e boot -o bootx64.efi
