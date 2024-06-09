# 타겟 아키텍처와 CPU를 지정합니다.
ARCH = armv7-a
MCPU = cortex-a8

# GNU ARM Embedded Toolchain의 도구들을 지정합니다.
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

# 링커 스크립트 파일의 경로를 지정합니다.
LINKER_SCRIPT = ./navilos.ld

# boot 디렉토리 내의 모든 어셈블리 소스 파일들을 찾습니다.
ASM_SRCS = $(wildcard boot/*.S)
# 어셈블리 소스 파일들을 대응하는 오브젝트 파일 경로로 변환합니다.
ASM_OBJS = $(patsubst boot/%.S, build/%.o, $(ASM_SRCS))

# 최종 생성될 실행 파일과 바이너리 파일의 경로를 지정합니다.
navilos = build/navilos.axf
navilos_bin = build/navilos.bin

# 실제 파일과 관련이 없는 타겟들을 지정합니다.
.PHONY: all clean run debug gdb

# 기본 타겟으로, navilos 실행 파일을 생성합니다.
all: $(navilos)

# 빌드 과정에서 생성된 파일들을 정리합니다.
clean:
	@rm -fr build

# QEMU 에뮬레이터를 사용하여 빌드된 커널을 실행합니다.
run: $(navilos)
	qemu-system-arm -M realview-pb-a8 -kernel $(navilos)

# 디버깅 모드에서 QEMU를 사용하여 커널을 실행합니다.
# GDB 서버가 TCP 포트 1234를 통해 대기 상태가 됩니다.
debug: $(navilos)
	qemu-system-arm -M realview-pb-a8 -kernel $(navilos) -S -gdb tcp::1234,ipv4

# GNU Debugger(GDB)를 시작합니다.
gdb:
	arm-none-eabi-gdb

# navilos 실행 파일을 생성하는 규칙입니다.
# 어셈블리 오브젝트 파일들과 링커 스크립트를 사용하여 링크합니다.
# 그런 다음 objcopy를 사용하여 바이너리 파일로 변환합니다.
$(navilos): $(ASM_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(navilos) $(ASM_OBJS)
	$(OC) -O binary $(navilos) $(navilos_bin)

# 각 어셈블리 소스 파일을 오브젝트 파일로 컴파일하는 규칙입니다.
# 필요한 디렉토리를 생성한 후 어셈블리 파일을 컴파일합니다.
build/%.o: boot/%.S
	mkdir -p $(shell dirname $@)
	$(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<
