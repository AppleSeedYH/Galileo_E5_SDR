function buff = addBuff(buff, item)
%ADD_BUFF  Shift elements left and insert new item at end.
%   buff = ADD_BUFF(buff, item) drops buff(1), shifts everything left, 
%   and sets the last element to item.

    % If buff is a row vector
    if isrow(buff)
        buff = [buff(2:end), item];
    % If buff is a column vector
    else
        buff = [buff(2:end); item];
    end
end
