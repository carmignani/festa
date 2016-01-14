function Spin = SpinFlip(Spin)
Spin(1)=pi-Spin(1);
Spin(2)=mod(Spin(2)+pi,6.283185307179586);
end
