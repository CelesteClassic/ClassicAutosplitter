import asyncio
import socket as sockets
import websockets
from sys import platform
import shutil
import os

picopath = shutil.which("pico8") if shutil.which("pico8") else ""

standalones = True if input("Are you using the standalones? (y/n) ") == "y" else False

if standalones:
    if platform == "darwin":
        picopath = "standalones/celeste_autosplit.app/Contents/MacOS/celeste_autosplit"
    elif platform == "win32":
        picopath = "standalones/windows/celeste_autosplit.exe"
    else:
        picopath = "standalones/linux/celeste_autosplit"
else:
    if platform == "darwin":
        picopath = "/Applications/PICO-8.app/Contents/MacOS/pico8"
    elif platform == "win32":
        picopath = "C:\\Program Files (x86)\\PICO-8\\pico8.exe"

    if not os.path.exists(picopath):
        picopath = input("Couldn't find pico-8 executable, please input the path to it here: ")

web = True if input("Are you using LiveSplitOne? (y/n) ") == "y" else False

if web:
    print("Connect to ws://localhost:5000 in one.livesplit.org")

socket = None
if not web:
    socket = sockets.socket(sockets.AF_INET, sockets.SOCK_STREAM)
    socket.connect(("localhost", 16834))
    socket.send(b"initgametime\r\n")

async def autosplitter(websocket, path):
    cmd = picopath
    proc = await asyncio.create_subprocess_shell(
        cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE)
    c = 0
    if websocket:
        await websocket.send("initgametime")
    
    while True:
        b = bytes([i for i in (await proc.stdout.readline()) if i != 194])
       
        if b[0] == 185:
            time = b[1:9].decode().split(":")

            minutes = int(time[0])
            seconds = float(time[1])

            total_seconds = minutes*60 + seconds
            if websocket:
                await websocket.send(f"setgametime {total_seconds}")
            else:
                socket.send(f"setgametime {total_seconds}\r\n".encode())

        elif b[0] == 178:
            if b[1] == 179:
                
                if websocket:
                    await websocket.send("start")
                else:
                    socket.send(b"starttimer\r\n")
            if b[1] == 185:
                time = b[2:10].decode().split(":")

                minutes = int(time[0])
                seconds = float(time[1])

                total_seconds = minutes*60 + seconds
                
                if websocket:
                    await websocket.send("pausegametime")
                    await websocket.send(f"setgametime {total_seconds}")
                    await websocket.send("split")
                    await websocket.send("resumegametime")
                else:
                    socket.send(f"setgametime {total_seconds}\r\nsplit\r\n".encode())

            if b[1] == 178:

                if websocket:
                    await websocket.send("reset")
                else:
                    socket.send(b"reset\r\n")
        elif (b.decode().startswith("!")):
            print(b.decode()[1:])


async def main():
    async with websockets.serve(autosplitter, "localhost", 5000):
        await asyncio.Future()


if not web:
    asyncio.run(autosplitter(None, None))
else:
    asyncio.run(main())