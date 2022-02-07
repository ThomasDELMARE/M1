"""
Graph from ESP32 Serial link
Run photoresitor sketch in same time !

Author : G.MENEZ

"""
import sys, serial
import numpy as np
import json
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
    def __init__(self, analogDataLight):
        plt.ion()                 # set plot to "animated"
        self.fig = plt.figure()
        self.fig, (ax1, ax2) = plt.subplots(2, 1)
        ax1.plot(analogDataLight.x, analogDataLight.y,
                                    'r.-', label="Light")
        ax2.plot(analogDataLight.x, analogDataLight.y,
                                    'r.-', label="Light")                    

        plt.xlabel('sample idx')
        plt.ylabel('sample value (12 bits ?)')
        #plt.xlim([0, 100])
        #plt.ylim([0, 4000])
        self.decoration("Analog Signal")
        
    def updateplot(self, analogData):
        """  update plot """
        
        self.ax1.set_xdata(analogData.x)
        self.ax2.set_ydata(analogData.y)

        self.fig.canvas.draw()
        self.fig.canvas.flush_events()
        #        self.ax.autoscale()
        self.ax1.relim()            # reset intern limits of the current axes
        self.ax1.autoscale_view()   # reset axes limits 
    
    def decoration(self, title):
        plt.title(title)
        plt.grid(True)
        plt.legend()


#----------------  Main function -----------------
def main():
    # Ring buffer of last samples 
    # analogData = AnalogData()
    # # plotting canvas
    # analogPlot = AnalogPlot(analogData)    
    
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
            jsonSend = ser.readline()
            tab = json.loads(jsonSend)
            light = tab["light"]
            print("Light value : ", light)

            # Plot
            # analogData.add(counter, light)
            # analogPlot.updateplot(analogData)
            # print('plotting new data...')
            
        except KeyboardInterrupt:
            print('exiting')
            break
        
        counter += 1
    
    # close serial
    ser.flush()
    ser.close()
    
#------------------ call main -----------------------

if __name__ == '__main__':
    main()