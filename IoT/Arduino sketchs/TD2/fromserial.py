"""
Graph from ESP32 Serial link
Run photoresitor sketch in same time !

Author : G.MENEZ

"""
import json
import sys, serial
import numpy as np
from time import sleep
from collections import deque
from matplotlib import pyplot as plt

#=============================================

class AnalogData:
    
    def __init__(self, maxLen=100):
        """ Ring Buffer de maxLen samples """        
        self.x = []
        self.y = []
        self.maxLen = maxLen

    def add(self, x, y):
        """ Add a sample in the  ring buffer """
        if len(self.x) == self.maxLen:
            self.x.pop(0)
            self.y.pop(0)
                        
        self.x.append(x)
        self.y.append(y)
    
#=============================================

class AnalogPlot:
    """ Plotting Figure """
    def __init__(self, analogData):
        plt.ion()                 # set plot to "animated"
        # self.fig = plt.figure()
        # self.ax = self.fig.add_subplot(111)
        # self.axline, = self.ax.plot(analogData.x, analogData.y,
        #                             'r.-', label="COM3")
        

        plt.xlabel('sample idx')
        plt.ylabel('sample value (12 bits ?)')
        #plt.xlim([0, 100])
        #plt.ylim([0, 4000])
        self.decoration("Analog Signal")
        
    def updateplot(self, analogData):
        """  update plot """
        self.axline.set_xdata(analogData.x)
        self.axline.set_ydata(analogData.y)

        self.fig.canvas.draw()
        self.fig.canvas.flush_events()
        #        self.ax.autoscale()
        self.ax.relim()            # reset intern limits of the current axes
        self.ax.autoscale_view()   # reset axes limits 
    
    def decoration(self, title):
        plt.title(title)
        plt.grid(True)
        plt.legend()
        
#----------------  Main function -----------------
def main():
    # Ring buffer of last samples 
    analogData = AnalogData()
    # plotting canvas
    analogPlot = AnalogPlot(analogData)    
    
    # open serial port
    ser = serial.Serial(
        port='COM3',
        baudrate = 9600,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS,
        timeout=3
    )
    
    counter=0
    while True:
        try:
            # Read
            v = ser.readline()
            v = v.rstrip()
            decodedString = v.decode('utf8')
                 
            if decodedString != "":
                jsonArray = json.loads(decodedString)
                temperature = jsonArray['temperature']
                print("Temperature value : ", temperature)

                lumiere = jsonArray['luminosite'] 
                redValue = jsonArray['redLed'] 
                greenValue = jsonArray['greenLed'] 

                # Plot
                analogData.add(counter, lumiere)
                analogPlot.updateplot(analogData)
                print('plotting new data...')
                
        except KeyboardInterrupt or UnicodeDecodeError:
            print('exiting')
            break
        
        counter += 1
    
    # close serial
    ser.flush()
    ser.close()
    
#------------------ call main -----------------------

if __name__ == '__main__':
    main()
