function [ xe ] = depcm( code, delta )
%DEPCM ����������ƺ���
%   �˴���ʾ��ϸ˵��
cdlen = length(code);
Dk = 0;  % �����Ԥ������ʼ״̬
xe = zeros(1, cdlen);
for k=1:cdlen
    if(code(k)>0)
        err = delta;
    else
        err = -delta;
    end
    xe(k) = Dk + err;  % ������
    Dk = xe(k);
end

end

