function prob = ProbFlip(Spin,PolTime)
    prob= (1/PolTime) * ...
        (1 + 0.923760430703401*cos(Spin(1))...
        -0.222222222222222*sin(Spin(1))*sin(Spin(2)));
% 8/(5*sqrt(3))=0.923760430703401
end
