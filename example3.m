%sine wave
t=[0:1e-6:1e-3]';
f=3e3;
y=sin(2*pi*f.*t);
plot(t,y);