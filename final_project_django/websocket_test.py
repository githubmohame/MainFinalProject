from websocket import create_connection
import websocket
import _thread
import time
import rel

def on_message(ws, message):
    pass

def on_error(ws, error):
    pass

def on_close(ws, close_status_code, close_msg):
    pass

def on_open(ws):
    pass

if __name__ == "__main__":
    websocket.enableTrace(True)
    ws = websocket.WebSocket("wss://api.gemini.com/v1/marketdata/BTCUSD",
                              on_open=on_open,
                              on_message=on_message,
                              on_error=on_error,
                              on_close=on_close)
wsc=create_connection('ws://127.0.0.1:8000/' )
ws.send('{"event":"subscribe", "subscription":{"name":"trade"}, "pair":["XBT/USD","XRP/USD"]}')

# Infinite loop waiting for WebSocket data
while True:
    print(ws.recv())