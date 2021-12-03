function stitched_img = stitchImg(direction, varargin)

    img_no = length(varargin);

    if direction == "row"
        middle = ceil(img_no / 2);
        temp_left = varargin{1};
        temp_right = varargin{img_no};

        % left part
        for img = 1: middle - 1
            imgs = temp_left;
            imgd = varargin{img + 1};
            [xs, xd] = genSIFTMatches_2(imgs, imgd);

            ransac_n = 100;
            ransac_eps = 5; 
            [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

            [imgs_y, imgs_x, ~] = size(imgs);
            [imgd_y, imgd_x, ~] = size(imgd);
            
            [T_3x3, x_range, y_range] = predict_size(H_3x3, imgs_y, imgs_x);
            width = x_range + imgd_x;
            height = max(imgd_y, y_range);
            dest_canvas_width_height = [width, height];
            
            [dest_mask, dest_img] = backwardWarpImg(imgs, inv(T_3x3 * H_3x3), dest_canvas_width_height);
            [src_mask, src_img] = backwardWarpImg(imgd, inv(T_3x3), dest_canvas_width_height);

            stitched_img_left = blendImagePair(dest_img, dest_mask, src_img, src_mask, 'blend');
            temp_left = im2single(delete_right(stitched_img_left));
        end
        % right part
        for img = img_no - 1: -1: middle + 1
            imgs = temp_right;
            imgd = varargin{img};
            [xs, xd] = genSIFTMatches_2(imgs, imgd);

            ransac_n = 100;
            ransac_eps = 5; 
            [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

            [imgs_y, imgs_x, ~] = size(imgs);
            [imgd_y, imgd_x, ~] = size(imgd);
            
            [T_3x3, x_range, y_range] = predict_size(H_3x3, imgs_y, imgs_x);
            width = x_range + imgd_x;
            height = max(imgd_y, y_range);
            dest_canvas_width_height = [width, height];
            
            [dest_mask, dest_img] = backwardWarpImg(imgs, inv(T_3x3 * H_3x3), dest_canvas_width_height);
            [src_mask, src_img] = backwardWarpImg(imgd, inv(T_3x3), dest_canvas_width_height);

            stitched_img_right = blendImagePair(src_img, src_mask, dest_img, dest_mask, 'blend');
            temp_right = im2single(delete(stitched_img_right));
        end
        imgs = temp_right;
        imgd = temp_left;
        [xs, xd] = genSIFTMatches_2(imgs, imgd);

        ransac_n = 100;
        ransac_eps = 5; 
        [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

        [imgs_y, imgs_x, ~] = size(imgs);
        [imgd_y, imgd_x, ~] = size(imgd);

        [T_3x3, x_range, y_range] = predict_size(H_3x3, imgs_y, imgs_x);
        width = x_range + imgd_x;
        height = max(imgd_y, y_range);
        dest_canvas_width_height = [width, height];
        
        [dest_mask, dest_img] = backwardWarpImg(imgs, inv(T_3x3 * H_3x3), dest_canvas_width_height);
        [src_mask, src_img] = backwardWarpImg(imgd, inv(T_3x3), dest_canvas_width_height);

        stitched_img = blendImagePair(src_img, src_mask, dest_img, dest_mask, 'blend');
        stitched_img = delete_right(stitched_img);
    end
    
    if direction == "column"
        middle = ceil(img_no / 2);
        temp_upper = varargin{1};
        temp_lower = varargin{img_no};

        % up part
        for img = 1: middle - 1
            imgs = temp_upper;
            imgd = varargin{img + 1};
            [xs, xd] = genSIFTMatches_2(imgs, imgd);

            ransac_n = 100;
            ransac_eps = 5; 
            [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

            [imgs_y, imgs_x, ~] = size(imgs);
            [imgd_y, imgd_x, ~] = size(imgd);
            
            [T_3x3, x_range, y_range] = predict_size(H_3x3, imgs_y, imgs_x);
            width = max(imgd_x, x_range);
            height = imgd_y + y_range;
            dest_canvas_width_height = [width, height];
            
            [dest_mask, dest_img] = backwardWarpImg(imgs, inv(T_3x3 * H_3x3), dest_canvas_width_height);
            [src_mask, src_img] = backwardWarpImg(imgd, inv(T_3x3), dest_canvas_width_height);

            stitched_img_upper = blendImagePairVertical(dest_img, dest_mask, src_img, src_mask, 'blend');
            temp_upper = im2single(delete_lower(stitched_img_upper));
        end
        % lower part
        for img = img_no - 1: -1: middle + 1
            imgs = temp_lower;
            imgd = varargin{img};
            [xs, xd] = genSIFTMatches_2(imgs, imgd);

            ransac_n = 100;
            ransac_eps = 5; 
            [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

            [imgs_y, imgs_x, ~] = size(imgs);
            [imgd_y, imgd_x, ~] = size(imgd);
            
            [T_3x3, x_range, y_range] = predict_size(H_3x3, imgs_y, imgs_x);
            width = max(imgd_x, x_range);
            height = imgd_y + y_range;
            dest_canvas_width_height = [width, height];
            
            [dest_mask, dest_img] = backwardWarpImg(imgs, inv(T_3x3 * H_3x3), dest_canvas_width_height);
            [src_mask, src_img] = backwardWarpImg(imgd, inv(T_3x3), dest_canvas_width_height);

            stitched_img_lower = blendImagePairVertical(src_img, src_mask, dest_img, dest_mask, 'blend');
            temp_lower = im2single(delete_lower(stitched_img_lower));
        end
        imgs = temp_lower;
        imgd = temp_upper;
        [xs, xd] = genSIFTMatches_2(imgs, imgd);

        ransac_n = 100;
        ransac_eps = 5; 
        [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

        [imgs_y, imgs_x, ~] = size(imgs);
        [imgd_y, imgd_x, ~] = size(imgd);
        
        [T_3x3, x_range, y_range] = predict_size(H_3x3, imgs_y, imgs_x);
        width = max(imgd_x, x_range);
        height = imgd_y + y_range;
        dest_canvas_width_height = [width, height];
        
        [dest_mask, dest_img] = backwardWarpImg(imgs, inv(T_3x3 * H_3x3), dest_canvas_width_height);
        [src_mask, src_img] = backwardWarpImg(imgd, inv(T_3x3), dest_canvas_width_height);

        stitched_img = blendImagePairVertical(src_img, src_mask, dest_img, dest_mask, 'blend');
        stitched_img = delete_lower(stitched_img);
    end
end

% This function is borrowed and modified from challenge 1c.
function [xs, xd] = genSIFTMatches_2(imgs, imgd)

if ~isequal(exist('vl_sift'), 3)
    sift_lib_dir = fullfile('sift_lib', ['mex' lower(computer)]);
    orig_path = addpath(sift_lib_dir);
    % Restore the original path upon function completion 
    temp = onCleanup(@()path(orig_path));
end

gray_s = rgb2gray(imgs);
gray_d = rgb2gray(imgd);

[Fs, Ds] = vl_sift(gray_s);
[Fd, Dd] = vl_sift(gray_d);

[matches, scores] = vl_ubcmatch(Ds, Dd);

xs = Fs(1:2, matches(1, :))';
xd = Fd(1:2, matches(2, :))';

end

% This function predicts the boundary after warping and produces
% a tranformation matrix for shifting
% and canvas width/height

function [T_3x3, x_range, y_range] = predict_size(H_3x3, y, x)
    corners = [1,1,1; 1,y,1; x,1,1; x,y,1];
    x_s = [];
    y_s = [];
    for t = 1:4
        res = H_3x3 * corners(t, :).';
        x_s = [x_s, res(1,1) / res(3,1)];
        y_s = [y_s, res(2,1) / res(3,1)];
    end
    x_min = min(x_s); x_max = max(x_s);
    y_min = min(y_s); y_max = max(y_s);
    x_range = x_max - x_min; y_range = y_max - y_min;
    
    t_x = 0; t_y = 0;
    if x_min < 0
        t_x = -x_min;
    end
    if y_min < 0
        t_y = -y_min;
    end
    
    T_3x3 = [1, 0, t_x; 0, 1, t_y; 0, 0, 1];
    
end

% This function deletes empty spaces on the right
function img = delete_right(img)
    [y, x, ~] = size(img);
    for j = x: -1: 1
        for i = 1:y
            for t = 1:3    
                if img(i,j,t) ~= 0
                    return
                end
            end
        end
        img(:, j, :) = [];
    end
end

% This function deletes empty spaces on the bottom
function img = delete_lower(img)
    [y, x, ~] = size(img);
    for i = y: -1: 1
        for j = 1:x
            for t = 1:3    
                if img(i,j,t) ~= 0
                    return
                end
            end
        end
        img(i, :, :) = [];
    end
end

function out_img = blendImagePairVertical(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
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
        upper = upper_bound(maskd);
        lower = lower_bound(masks);
        
        for i = 1:src_res_y
            for j = 1:src_res_x
                if masks(i,j) ~= 0
                    src_mask(i,j) = src_mask(i,j) * cal_w1(i, upper, lower);
                end
            end
        end
        for i = 1:dest_res_y
            for j = 1:dest_res_x
                if masks(i,j) ~= 0
                    dest_mask(i,j) = dest_mask(i,j) * cal_w2(i, upper, lower);
                end
            end
        end
        out_img = im2double(wrapped_imgs) .*...
            cat(3, src_mask, src_mask, src_mask) +...
            im2double(wrapped_imgd) .*...
            cat(3, dest_mask, dest_mask, dest_mask);
        
    end
end

function bound = upper_bound(img_mask)
    [y, x] = size(img_mask);
    for i = 1:y
        for j = 1:x
            if img_mask(i, j) ~= 0
                bound = i;
                return
            end
        end
    end
end

function bound = lower_bound(img_mask)
    [y, x] = size(img_mask);
    for i = y:-1:1
        for j = 1:x
            if img_mask(i, j) ~= 0
                bound = i;
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
