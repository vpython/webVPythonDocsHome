from vpython import *

p1 = {'pos':vec(-1,-1,0), 'radius':0.05, 'color':color.red}
p2 = {'pos':vec(0,1,0), 'radius':0.15, 'color':color.cyan}
p3 = {'pos':vec(1,-1,0), 'radius':0.05, 'color':color.red}

# p1 = dict(pos=vec(-1,-1,0), radius=0.05, color=color.red)
# p2 = dict(pos=vec(0,1,0), radius=0.15, color=color.cyan)
# p3 = dict(pos=vec(1,-1,0), radius=0.05, color=color.red)


c = curve( [p1,p2,p3] )


# ff = frame()

