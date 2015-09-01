% function [ velocity ] = extractV(x, tpoints, sump)
%EXTRACTV
% calculates the velocity of the expansion from simulation curves

n = 10;

t = tpoints(end-n+1:end);
p = sump(:,end-n+1:end);

% half max method

for i = 1:length(t)


end
figure
plot(t,halfmax)


% figure(1);
% plot(x, p)


% end

