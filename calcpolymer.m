function [ polymer ] = calcpolymer(input, mode)
%CALCPOLYMER 
%  
% input is matrix of size m-by-n with m=n such as p and q, which is the state variable for my simulation
% 
% for either p or q, element (i, j) = plus end position i*dx and length q*dx
% thus, diagonal entries correspond to microtubules with minus end at origin
% the output polymer is an array 1-by-n where each entry is the local density of the polymer
% 

% if length(nonzeros(triu(input,1))) > 0
%     error('non zero elements in upper righthand triangle of the matrix')
% end


%% dynamic programming, works! 9/24/2016

if strcmp(mode,'dp')
    
    [m n] = size(input);
    polymer = zeros(n,1);

    plusends = sum(input,2);
    ind = max(find(plusends));
    
    for j = 1:ind    
        if j == 1
            polymer(j) = sum(diag(input));
        else
%             input(j-1,:)
%             diag(input,1-j)
            polymer(j) = polymer(j-1) - sum(input(j-1,:)) + sum(diag(input,1-j));
        end 
    end
end

%% using diagonal sum nested loop

if strcmp(mode,'diag')

    [m n] = size(input);
    
    polymer = zeros(n,1);

    for j = 1:n       
        tot = 0;
        for k = 1:j
            d = diag(input,k-j);
            tot = tot+sum(d(k:end));
        end
        polymer(j) = tot;
    end

end

%% this is my initial really inefficient way of calculating from 9/22/2016

if strcmp(mode,'dumb')

    [m n] = size(input);

    polymer = zeros(n,1);

    for j = 1:n

        % create binary mask
        mask = zeros(m,n);
        for k = j:n
            mask(k,:) = [zeros(1,k-j) ones(1,j) zeros(1,n-k)];
        end

        % store sum of matrix
        polymer(j) = sum(sum(mask.*input));

    end

end

end

