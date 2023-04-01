function codeout = dltpcm_adp( x, delta, kup, kdown )
%DLTPCM_ADP 此自适应增量编码程序
xlen = length(x);
Di = 0;
err1 = 0;
err2 = 0;
for i =1:xlen
    err1 = x(i) - Di;
    if(err1>=0)
        codeout(i) = 1;
        qout = delta;
    else
        codeout(i) = -1;
        qout = -delta;
    end
    if i>1
        if(err1*err2>=0)
            delta = kup*delta;
        else
            delta = kdown*delta;
        end
    end
    Di = Di + qout;
    err2 = err1;
end
end


