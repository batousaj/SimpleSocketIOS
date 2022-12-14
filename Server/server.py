import socket
import sys

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('127.0.0.1', 12345)
print ('starting up on ', server_address[0] ,' port ' ,server_address[1])
sock.bind(server_address)

# Listen for incoming connections
sock.listen(5)

while True:
    # Wait for a connection
    print ("waiting for a connection")
    connection, client_address = sock.accept()
    
    try:
        print ('connection from', client_address)

        # Receive the data in small chunks and retransmit it
        while True:
            data = connection.recv(1024)
            print ('received ', data)
            if data:
                connection.sendall(b'Hello Thien, I am machine')
                print('sending data back to the client')
            else:
                print ('no more data from', client_address)
                break
            
    finally:
        # Clean up the connection
        connection.close()
