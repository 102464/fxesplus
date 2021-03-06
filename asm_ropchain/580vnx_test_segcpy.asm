# Test writing to/reading from segments other than 0 using boot initialization routine.
# Requires 0xa2 (xnor) | 0xa1 (xor)

# RESULT: Works. If 0x40 is replaced with 0x30 then it no longer works.

	adr_of x # er12
	0x33  # 4 bytes [xr8]
	0x31
	0x40  # er10 = 0 (mod 16)
	0x32

home:
	org 0xd544 # mode 100 + 10

	call 0x17cad  # lea [er12]; st r0..r9 -> [ea+]; rt

	#call 0xa1d8
	#call 0xa210
	call 0xa222 # noreturn?


	0x30313233 # pad

x:
	0x30313233343536373839 # 10 bytes, will be overwritten

#	source;  dest ; count ; sseg; dseg
#	0x3130; 0xfe60; 0xfe01; 0x01; 0x00  # WORKED

# 3 lines. RESULT: white [4:a630 is not writable]
#	0x3130; 0xa630; 0x3131; 0x41; 0x44
#	0x3130; 0xfe60; 0x3101; 0x44; 0x40
#	0x3233; 0x3233; 0xe7e7; 0x41; 0x41   # DELAY

# 12 lines. RESULT: 8:fbxx / 5:fbxx are not writable.
	0x3130; 0xfb30; 0x311a; 0x41; 0x48
	0xfb30; 0xfe1a; 0x3101; 0x48; 0x40
	0x3233; 0x3233; 0xe7e7; 0x41; 0x41   # DELAY

	0x3130; 0xfe30; 0x3101; 0x41; 0x48
	0xfe30; 0xfe01; 0x3101; 0x48; 0x40
	0x3233; 0x3233; 0xe7e7; 0x41; 0x41   # DELAY

	0x3130; 0xfb30; 0x311a; 0x41; 0x45
	0xfb30; 0xfe1a; 0x3101; 0x45; 0x40
	0x3233; 0x3233; 0xe7e7; 0x41; 0x41   # DELAY

	0x3130; 0xfe30; 0x3101; 0x41; 0x45
	0xfe30; 0xfe01; 0x3101; 0x45; 0x40
	0x3233; 0x3233; 0xe7e7; 0x41; 0x41   # DELAY


#	0x3130; 0xfe60; 0x3101; 0x40; 0x40
#	0x3233; 0x3233; 0xe7e7; 0x41; 0x41   # DELAY
#	0x3130; 0xfe50; 0x3101; 0x40; 0x40
#	0x3233; 0x3233; 0xe7e7; 0x41; 0x41   # DELAY
#	0x3130; 0xfe30; 0x3101; 0x40; 0x40


# NOTE: clock speed ~= 1 MHz = 0x100000 Hz. Odd copy: 6 commands per byte. Expect min 1/2 second.

# Screen: row 1: 0xf820, row 2: 0xf840, etc.
# content to test copy to screen: 0:3130 (non empty)
