import time, serial

ser = serial.Serial(
    port = 'COM3',
    baudrate = 9600,
    parity = serial.PARITY_NONE,
    stopbits = serial.STOPBITS_ONE,
    bytesize = serial.EIGHTBITS,
    timeout = 1
)

while True:
    try:
        x=ser.readline()
        x= x.rstrip()
        x=x.decode("utf-8")
        
        print("Valeur : ", format(x))
    
    except KeyboardInterrupt:
        print("exiting")
        break
        
ser.flush()
ser.close()
        