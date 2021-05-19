local charset = {}  do -- makes this: qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

local key = ""

for i = 1, 20 do
	math.randomseed(game:GetService("Lighting").ClockTime ^ 5)
	key = key .. charset[math.random(1, #charset)]
end

print("Key generated: " .. key .. ", now sending request to whitelist server...")

local C2SKeyResponse = syn.request({-- client to server
	Url = "https://entropix.000webhost.com/whitelist.php",
	Method = "POST",
	Headers = {
		Key = key
	}
})

print("Response recieved, answer is " .. C2SKeyResponse.Body)

