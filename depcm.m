function [ xe ] = depcm( code, delta )
%DEPCM 增量解码调制函数
%   此处显示详细说明
cdlen = length(code);
Dk = 0;  % 解码端预测器初始状态
xe = zeros(1, cdlen);
for k=1:cdlen
    if(code(k)>0)
        err = delta;
    else
        err = -delta;
    end
    xe(k) = Dk + err;  % 解码结果
    Dk = xe(k);
end

end

