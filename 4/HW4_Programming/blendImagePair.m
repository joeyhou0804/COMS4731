function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
    [src_res_y, src_res_x] = size(masks);
    [dest_res_y, dest_res_x] = size(maskd);
    
    src_mask(1:src_res_y, 1:src_res_x) = 1;
    dest_mask(1:dest_res_y, 1:dest_res_x) = 1;   
    
    if mode == "overlay"
        for i = 1:src_res_y
            for j = 1:src_res_x
                if masks(i,j) ~= 0 && maskd(i,j) == 0
                    src_mask(i,j) = 0;
                end
            end
        end
        for i = 1:dest_res_y
            for j = 1:dest_res_x
                if maskd(i,j) ~= 0
                    dest_mask(i,j) = 0;
                end
            end
        end
        src_mask = ~src_mask;
        dest_mask = ~dest_mask;
        out_img = im2double(wrapped_imgs) .* cat(3, src_mask, src_mask, src_mask)...
            + im2double(wrapped_imgd) .* cat(3, dest_mask, dest_mask, dest_mask);
    end
    
    if mode == "blend"
        left = left_bound(maskd);
        right = right_bound(masks);
        
        for i = 1:src_res_y
            for j = 1:src_res_x
                if masks(i,j) ~= 0
                    src_mask(i,j) = src_mask(i,j) * cal_w1(j, left, right);
                end
            end
        end
        for i = 1:dest_res_y
            for j = 1:dest_res_x
                if masks(i,j) ~= 0
                    dest_mask(i,j) = dest_mask(i,j) * cal_w2(j, left, right);
                end
            end
        end
        out_img = im2double(wrapped_imgs) .*...
            cat(3, src_mask, src_mask, src_mask) +...
            im2double(wrapped_imgd) .*...
            cat(3, dest_mask, dest_mask, dest_mask);
        
    end
end

function bound = left_bound(img_mask)
    [y, x] = size(img_mask);
    for j = 1:x
        for i = 1:y
            if img_mask(i, j) ~= 0
                bound = j;
                return
            end
        end
    end
end

function bound = right_bound(img_mask)
    [y, x] = size(img_mask);
    for j = x:-1:1
        for i = 1:y
            if img_mask(i, j) ~= 0
                bound = j;
                return
            end
        end
    end
end

function w1 = cal_w1(x, l_bound, r_bound)
    if x <= l_bound
        w1 = 1;
    elseif x >= r_bound
        w1 = 0;
    else
        range = r_bound - l_bound;
        step = 1 / range;
        w1 = 1 - step * (x - l_bound);
    end
end

function w2 = cal_w2(x, l_bound, r_bound)
    if x <= l_bound
        w2 = 0;
    elseif x >= r_bound
        w2 = 1;
    else
        range = r_bound - l_bound;
        step = 1 / range;
        w2 = step * (x - l_bound);
    end
end
