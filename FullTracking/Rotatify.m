function R = Rotatify( M )
%   R = Rotatify( M )
%   M is a rotation matrix with some noise, so not a perfect rotation, and
%   R is a true rotation matrix, with R'*R=I
%
%   Formula from Finding the nearest orthonormal matrix, no author, found
%   with google.

R=M*(M'*M)^-0.5;

end

