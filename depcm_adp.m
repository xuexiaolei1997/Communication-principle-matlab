function xe = depcm_adp( code, delta, kup, kdown )
%DEPCM_ADP 自适应增量解码程序
cdlen = length(code);
Di = 0;  % 解码端预测器初始状态
xe = zeros(1, cdlen);
for i=1:cdlen
    if(code(i)>0)
        qout = delta;
    else
        qout = -delta;
    end
    xe(i) = Di + qout;  % 解码结果
    Di = xe(i);
    if i>1
        if(code(i-1)*code(i)>0)
            delta = kup*delta;
        else
            delta = kdown*delta;
        end
    end
end
end

