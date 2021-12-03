function mask = computeMask(img_cell)
    temp = double(img_cell{1});
    for i = 2:length(img_cell)
        temp = temp + double(img_cell{i});
    end
    temp(temp ~= 0) = 1;
    mask = temp;
end
