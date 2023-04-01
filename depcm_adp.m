function xe = depcm_adp( code, delta, kup, kdown )
%DEPCM_ADP ����Ӧ�����������
cdlen = length(code);
Di = 0;  % �����Ԥ������ʼ״̬
xe = zeros(1, cdlen);
for i=1:cdlen
    if(code(i)>0)
        qout = delta;
    else
        qout = -delta;
    end
    xe(i) = Di + qout;  % ������
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

