function elemSpinMat=CalcSpRotMat(BA,dpx,dpy,delta,nusp)
%   elemSpinMat=CalcSpRotMat(BA,dpx,dpy,delta,nusp)
%

dxp=-BA/(1+delta)+dpx;
dyp=dpy/(1+delta);

thetaMagnet=sqrt(dxp^2+dyp^2);
if thetaMagnet~=0
    u=[-dyp,dxp,0]/thetaMagnet;
    thetaSp=thetaMagnet*(nusp*(1+delta)+1);
    ct=cos(thetaSp);
    st=sin(thetaSp);
    %formula from rotation matrix wikipedia
    %(rotation matrix from axis and angle)
    elemSpinMat=[ct + u(1)^2*(1-ct),    u(1)*u(2)*(1-ct),   u(2)*st;...
        u(1)*u(2)*(1-ct),      ct + u(2)^2*(1-ct), -u(1)*st;...
        -u(2)*st,              u(1)*st,            ct];
else
    elemSpinMat=eye(3);
end
% return
% 
% dxp=-BA+dpx/(1+delta);
% dyp=dpy/(1+delta);
% 
% thetaMagnet=sqrt(dxp^2+dyp^2);
% if thetaMagnet~=0
%     u=[-dyp,dxp,0]/thetaMagnet;
%     thetaSp=thetaMagnet*(nusp*(1+delta)+1);
%     ct=cos(thetaSp);
%     st=sin(thetaSp);
%     %formula from rotation matrix wikipedia
%     %(rotation matrix from axis and angle)
%     elemSpinMat=[ct + u(1)^2*(1-ct),    u(1)*u(2)*(1-ct),   u(2)*st;...
%         u(1)*u(2)*(1-ct),      ct + u(2)^2*(1-ct), -u(1)*st;...
%         -u(2)*st,              u(1)*st,            ct];
% else
%     elemSpinMat=eye(3);
% end
