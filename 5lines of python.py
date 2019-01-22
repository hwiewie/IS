numwrites=random.randrange(math.ceil((float(len(buf)) / FuzzFactor))) +1
for j in range(numwrites):
  rbyte = random.randrange(256)
  rn = random.randrange(len(buf))
  buf[rn] = "%c"%(rbyte);
