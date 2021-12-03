function refocusApp(rgb_stack, depth_map)
    [row, col, len] = size(rgb_stack);
    len = len / 3;    
    
    imshow(rgb_stack(:, :, 1:3), 'Border', 'loose');
    [x,y] = ginput(1);
    cur_i = 1;
    
    while y >= 1 && y <= row && x >= 1 && x <= col
        max_i = depth_map(round(y),round(x));
        while cur_i ~= max_i
            if cur_i == len
                cur_i = 1;
            else
                cur_i = cur_i + 1;
            end
            imshow(rgb_stack(:, :, 3 * cur_i - 2:3 * cur_i), 'Border', 'loose');
        end  
        [x,y] = ginput(1);
    end
end
