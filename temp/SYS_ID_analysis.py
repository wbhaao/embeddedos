 

data = input("input data : ")
data = int(data,16)

fpga = (data & 0xFF)
arch = (data & 0xF00) >> 8
build = (data & 0xF000) >> 12
hbi = (data & 0xFFF0000) >> 16
rev = (data & 0xF0000000) >> 28

if rev == 0 :
    print("Board revision : Rev A")
elif rev == 1 :
    print("Board revision : Rev B")
elif rev == 2 :
    print("Board revision : Rev C")
else :
    print("rev : {0}".format(rev))

print("hbi board number : {0}".format(hex(hbi)))


if arch == 0x4 :
    print("Bus architecture : AHB")
elif arch == 0x5 :
    print("Bus architecture : AXI")
else : 
    print("Bus : {0}".format(hex(bus)))
