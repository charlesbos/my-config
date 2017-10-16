#!/usr/bin/python3
#A script to parse the GTK recently used file and output the top 10 results
#in FVWM menu format

import os
import operator

recentFile = os.path.expanduser("~") + "/.local/share/recently-used.xbel"
file = open(recentFile, "r")
recentFileText = file.read()
file.close()
recentFileLines = recentFileText.split("\n")

files = []
for x in recentFileLines :
	if x.find("href") != -1 :
		added = ""
		modified = ""
		visited = ""
		if x.find("added") != -1 :
			added = \
			x[x.find("added") + 6:x.find(" ", x.find("added"))].strip('"')
		if x.find("modified") != -1 : 
			modified = \
			x[x.find("modified") + 9:x.find(" ", x.find("modified"))].strip('"')
		if x.find("visited") != -1 : 
			visited = \
			x[x.find("visited") + 8:x.find(" ", x.find("visited"))].strip('"')
		tStamps = [added, modified, visited]
		tStamps = sorted(tStamps, reverse = True)
		filename = \
		x.partition("file://")[2].split(" ")[0] \
		.replace("%20", " ").replace("&apos;", "'").strip('"')
		files.append([tStamps[0], filename])
	if x.find("<bookmark:application ") != -1 :
		app = x[x.find("exec") + 5:x.find(" ", x.find("exec"))]
		if app.find("%") != -1 : app = app[0:app.find("%")]
		app = app.replace("&apos;", "").strip("'").strip('"')
		files[-1].append(app)
files = sorted(files, key = operator.itemgetter(0), reverse = True)

print("DestroyMenu recreate RecentFiles")
print("AddToMenu RecentFiles \"Recent Files\" Title")
for x in files[:10] :
	print("+ \"" + os.path.basename(x[1]) + "\" Exec " + \
	x[2] + " \"" + x[1] + "\"")
