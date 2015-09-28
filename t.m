rs = [0:0.05:1.2];

v_theors = [];
v_theors2 = [];

for i = 1:length(rs)
    r = rs(i);
    [r_critical, v_theoretical, J] = theoretical( v1,v2,fcat,fres,r);
    
    v_theors  = [v_theors  sqrt(4*v1*v2/(fcat+fres)*r)];
    v_theors2 = [v_theors2 v_theoretical];

    
end

figure; plot(rs, v_theors, rs, v_theors2)
figure; plot(rs', (v_theors./v_theors2)')
