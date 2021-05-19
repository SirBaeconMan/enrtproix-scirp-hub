import discord
import socket
import sys

token = "ODMzMzAzODIyNDEwODQyMTIy.YHwYqQ._97b5FqE9KLxykmQuPuXvO7jYYM"

client = discord.Client()

@client.event
async def on_ready():
	print("Connected to Discord!")
	game = discord.Game('Amog "sus" :sob:')
	await client.change_presence(status=discord.Status.online, activity=game)

@client.event
async def on_message(message):
	if str(message.channel) == "key-check":
		HOST, PORT = "18.194.5.49", 80
		data = str(message.content)

		# Create a socket (SOCK_STREAM means a TCP socket)
		with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
			# Connect to server and send data
			sock.connect((HOST, PORT))
			sock.sendall(bytes(data + "\n", "utf-8"))

			# Receive data from the server and shut down
			received = str(sock.recv(1024), "utf-8")

		print("Sent:     {}".format(data))
		print("Received: {}".format(received))



client.run(token)