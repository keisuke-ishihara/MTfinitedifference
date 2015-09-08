function [ vchange ] = similarity( sump, x )
%SIMILARITY 

global dim

p1 = sump(:,end-2);
p2 = sump(:,end-1);
p3 = sump(:,end);

% normalize the number of plus ends with geometry
if dim == 1
elseif dim == 2
    [a b] = size(p1);
    p1 = p1./(repmat(2*pi*x/dx,b,1))';
    p2 = p2./(repmat(2*pi*x/dx,b,1))';
    p3 = p3./(repmat(2*pi*x/dx,b,1))';
else
    error
end



end

