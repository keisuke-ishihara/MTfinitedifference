clc; clear all;

ms = 5*2.^(1:1:5);

bs = zeros(length(ms),1);

for i = 1:length(ms)

    m = ms(i);
    input = ones(m,m);

    tic;

    a = calcpolymer(input);

    bs(i) = toc;

end

figure;
plot(log(ms), log(bs),'o')