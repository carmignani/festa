thx=.2;

cx=cos(thx);
sx=sin(thx);
R=[1,0,0;
   0,cx,-sx;
   0,sx,cx]

M=R+rand(3)/1000;

det(M)
M'*M
tic
for ii=1:10000
    RR=M*(M'*M)^-0.5;
end
toc
det(RR)
RR'*RR