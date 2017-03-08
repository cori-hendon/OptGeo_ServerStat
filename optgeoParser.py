# read the three newest input files
# grab the uptime duration and compare it to the last known value stored in separate file
#	if time increased, up
#	else down

import sys


infile = sys.argv[1]
reffile = sys.argv[2]

strg1Read = open(infile,"r")
strg1Ref = open(reffile,"r")

refTimeStr = ""
for line in strg1Ref:
	if line != "\n":
		refTimeStr = line

for line in strg1Read:
	if line != "\n":
		data=line.split(",  ")
		group = "Storage"
		name = infile.split(".")[0].split("/")[6]
		if name == "newest1":
			name = "strg001"
		elif name == "newest2":
			name = "strg002"
		elif name == "newest3":
			name = "strg003"
		elif name == "newest4":
			name = "strg004"
		uptimeRaw = data[0].strip()
		uptime = data[0].split("up")[1].strip()
		users = data[1].split("user")[0].strip()
		load = data[2].split(",")
		load01 = load[0].split(":")[1].strip()
		load05 = load[1].strip()
		load15 = load[2].strip()
		

		# strg1Ref.write(uptime + "\n")

		if uptimeRaw == refTimeStr:
			status = "Unknown"
		else:
			status = "Up"
			strg1Ref.close()
			strg1Ref = open(reffile,"w")
			strg1Ref.write(uptimeRaw)

		print group + "#" + name + "#" + status + "#" + uptime + "#" + users + "#" + load01 + "#" + load05 + "#" + load15
		



strg1Read.close()
strg1Ref.close()
