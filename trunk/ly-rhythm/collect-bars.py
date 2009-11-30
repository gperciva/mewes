#!/usr/bin/env python
import sys

PRINT_BARS = 0

try:
	timing_file = sys.argv[1]
except:
        print "Please enter the timing filename"
        sys.exit(1)

timings = open(timing_file).readlines()

# count in units of 384   (= 2^7 * 3)
# increase this number as needed; we don't want floats
UNIT = 384.0

timeSigTop = 4
timeSigBot = 4
timeBar = (UNIT / timeSigBot) * timeSigTop

# FIXME: hack for \partial
#position = UNIT*3/4
#measure_number = 0
position = 0
measure_number = 1

bar_string = ''
bar_types = {}

def timeSignature(nextTimeSigTop, nextTimeSigBot):
	timeSigTop = int(nextTimeSigTop[1:])
	timeSigBot = int(nextTimeSigBot[:-1])
	global timeBar, position
	if (PRINT_BARS):
		print "time signature:", timeSigTop, timeSigBot
	position += timeBar
	timeBar = (UNIT / timeSigBot) * timeSigTop
	position -= timeBar

def barLine():
	global bar_string, position, measure_number
	if (PRINT_BARS):
		print "m"+str(measure_number)+":", bar_string
	position -= timeBar 
	measure_number += 1
	try:
		bar_types[bar_string] += 1
	except KeyError:
		bar_types[bar_string] = 1
	bar_string = ''

def unit_dur(duration):
	multiplier = 1.0
	mul_add = 0.5
	dur_base = duration
	while (dur_base[-1] == '.'):
		multiplier += mul_add
		mul_add /= 2.0
		dur_base = dur_base[:-1]
	dur = int(dur_base)
	ticks = UNIT / dur
	ticks *= multiplier
	if (ticks != int(ticks)):
		print "ERROR: need to increase UNIT"
	return ticks

def partial(line):
	fraction = line[1][:-1].split('/')
	multiplier = int( fraction[0] )
	ticks = unit_dur( fraction[1] )
	adjustTime = multiplier * ticks
	global position, measure_number
	position += adjustTime
	measure_number -= 1

# FIXME: doesn't handle triplets yet!
def duration(duration):
	dur = unit_dur(duration)

	global bar_string, position, measure_number
	bar_string += duration
	position += dur
	if (position > timeBar):
		print "WARNING: exceeded bar line"
		barLine()
		print duration, position, bar_string
		sys.exit(1)
	if (position == timeBar):
		barLine()
	if (position == 0):
		barLine()
	else:
		bar_string += ' '

for line in timings:
	splitline = line.split()
	type = splitline[0]
	remainder = splitline[1:]
	if (type == 'd:'):
		duration(remainder[0])
	elif (type == 't:'):
		timeSignature(remainder[0], remainder[2])
	elif (type == 'p:'):
		partial(remainder)
	else:
		print line

if (position > 0):
	barLine()

for bar in iter(bar_types):
	print str(bar_types[bar]) + ':\t', bar



