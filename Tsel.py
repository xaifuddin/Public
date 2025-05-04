
import pygetwindow
import pyautogui
import time
import os
import sys
os.system('cls')

def click(win, xyStart, x, y, duration=0.2):
    if xyStart == 'LT':
        pyautogui.mouseDown(win.left + x, win.top + y)
    elif xyStart == 'RT':
        pyautogui.mouseDown(win.right - x, win.top + y)
    elif xyStart == 'LB':
        pyautogui.mouseDown(win.left + x, win.bottom - y)
    elif xyStart == 'RB':
        pyautogui.mouseDown(win.right - x, win.bottom - y)
    time.sleep(duration)
    pyautogui.mouseUp()

def TungguWarna(win, xyStart, x, y, target_color):
    while True:
        if xyStart == 'LT':
            color = pyautogui.pixel(win.left + x, win.top + y)
        elif xyStart == 'RT':
            color = pyautogui.pixel(win.right - x, win.top + y)
        elif xyStart == 'LB':
            color = pyautogui.pixel(win.left + x, win.bottom - y)
        elif xyStart == 'RB':
            color = pyautogui.pixel(win.right - x, win.bottom - y)
        if color == target_color:
            time.sleep(1.5)
            break
 
def TungguWarnaHilang(win, xyStart, x, y, target_color):
    while True:
        if xyStart == 'LT':
            color = pyautogui.pixel(win.left + x, win.top + y)
        elif xyStart == 'RT':
            color = pyautogui.pixel(win.right - x, win.top + y)
        elif xyStart == 'LB':
            color = pyautogui.pixel(win.left + x, win.bottom - y)
        elif xyStart == 'RB':
            color = pyautogui.pixel(win.right - x, win.bottom - y)
        if color != target_color:
            time.sleep(0.2)
            break

ss = pygetwindow.getWindowsWithTitle('SM-A325F')[0]
ss.activate()

n = 122
while True:
    # Menu utama
    if pyautogui.pixel(ss.left + 237, ss.top + 225) == (166, 205, 255):
        click(ss, 'LT', 100, 871) # Menu utama

    # Tukar
    if pyautogui.pixel(ss.left + 110, ss.top + 930) == (238, 2, 39):
        click(ss, 'LT', 100, 930) # Tukar

    # Lanjutkan
    if pyautogui.pixel(ss.left + 110, ss.top + 930) == (255, 255, 255):
        if pyautogui.pixel(ss.left + 110, ss.top + 864) == (238, 2, 39):
            if pyautogui.pixel(ss.left + 403, ss.top + 342) != (255, 255, 255):
                click(ss, 'LT', 100, 864) # Lanjutkan

    # Kembali
    if pyautogui.pixel(ss.left + 278, ss.top + 219) == (250, 176, 142):
        click(ss, 'LT', 100, 930) # Kembali
        n = n - 1
        print(n)

    if n == 0:
        # os.system('shutdown /s /t 1')
        break

    # Riwayat
    if pyautogui.pixel(ss.left + 456, ss.top + 183) == (208, 229, 254):
        click(ss, 'LT', 74, 106) # <==

    # Voucher tidak berlaku
    if pyautogui.pixel(ss.left + 110, ss.top + 930) == (234, 238, 242):
        if pyautogui.pixel(ss.left + 110, ss.top + 864) == (234, 238, 242):
            click(ss, 'LT', 74, 106) # <==

    # Error
    if pyautogui.pixel(ss.left + 120, ss.top + 864) == (255, 242, 223):
        click(ss, 'LT', 78, 97) # <==

    time.sleep(0.2)

print('DONE')
sys.exit()
