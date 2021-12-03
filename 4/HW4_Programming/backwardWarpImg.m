function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
    x_len = dest_canvas_width_height(1);
    y_len = dest_canvas_width_height(2);
    res(1:y_len, 1:x_len, 1:3) = 0;
    
    [src_row, src_col, ~] = size(src_img);
    for i = 1:y_len
        for j = 1:x_len
            res_pos = [j; i; 1];
            src_pos = resultToSrc_H * res_pos;
            for t = 1:3
                y_src = round(src_pos(2) / src_pos(3));
                x_src = round(src_pos(1) / src_pos(3));
                if y_src >= 1 && y_src <= src_row &&...
                    x_src >= 1 && x_src <= src_col
                    res(i, j, t) = src_img(y_src, x_src, t);
                end
            end
        end
    end
    result_img = res;
    
    mask(1:y_len, 1:x_len) = 0;
    for i = 1:y_len
        for j = 1:x_len
            if ~(result_img(i, j, 1) == 0 &&...
                    result_img(i, j, 2) == 0 &&...
                    result_img(i, j, 3) == 0)
                mask(i, j) = 1;
            end
        end
    end
end
