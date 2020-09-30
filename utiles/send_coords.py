#!/usr/bin/python3

import serial

COORDS_WIDTH = 8
LINES_TOTAL = 2961 #11946 Saque unas lineas para necesitar un bit menos de RAM addr

with open('coordenadas.txt') as fp, serial.Serial('/dev/ttyUSB0', 115200, timeout=1) as serial:
    for line_number, line in enumerate(fp):
        if line_number < LINES_TOTAL:

            x = int(float(line.split('\t')[0])*2**(COORDS_WIDTH-1))
            x_signed = True if x < 0 else False
            y = int(float(line.split('\t')[1])*2**(COORDS_WIDTH-1))
            y_signed = True if y < 0 else False
            z = -1*int(float(line.split('\t')[2])*2**(COORDS_WIDTH-1))
            z_signed = True if z < 0 else False

            serial.write((x).to_bytes(1, 'big', signed=x_signed))
            serial.write((y).to_bytes(1, 'big', signed=y_signed))
            serial.write((z).to_bytes(1, 'big', signed=z_signed))

            # imprimo coordenadas por pantalla a medida que las voy enviando, junto con su address
            print(f"Line {line_number}, RAM Address: {line_number*3}: X={hex(x)} Y={hex(y)} Z={hex(z)}")
