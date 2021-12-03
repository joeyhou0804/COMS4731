function [db, out_img] = compute2DProperties(orig_img, labeled_img)
    [L, num] = bwlabel(labeled_img);
    res = [];
    for i = 1:num
        % helperFunction is defined below this function
        arr = helperFunction(labeled_img, i);
        % save results in the 2d array
        res = [res; arr];
    end
    db = res.';
   
    fh1 = figure;
    imshow(orig_img);

    hold on;    
    for i = 1:num 
        % plot(x,y)
        plot(db(3,i), db(2,i),  'ws', 'MarkerFaceColor', [1 1 1]);
        cos_diff = cos(deg2rad(db(5,i)));
        sin_diff = sin(deg2rad(db(5,i)));
        line([db(3,i)-50 * cos_diff db(3,i)+50 * cos_diff],...
            [db(2,i)-50 * sin_diff db(2,i)+50 * sin_diff],...
            'LineWidth',2, 'Color', [0, 1, 0]);
    end
    out_img = saveAnnotatedImg(fh1);
end

% This is the helper function which is used here and in the next challenge
function arr = helperFunction(labeled_img, i)
    [r, c] = find(labeled_img == i);
    rc = [r c];

    % 1. object label
    arr = [i];

    % 2.row position of the center
    % (pixel: (y,x))
    area = length(rc);
    row_sum = 0;
    for j = 1:area
        row_sum = row_sum + rc(j,1);
    end
    row_center = row_sum / area;
    arr = [arr, row_center];

    % 3.column position of the center
    % (pixel: (y,x))
    col_sum = 0;
    for j = 1:area
        col_sum = col_sum + rc(j,2);
    end
    col_center = col_sum / area;
    arr = [arr, col_center];

    % 4.minimum moment of inertia
    % 5.orientation
    % (y'=y-y^, x'=x-x^)
    c = 0;
    for j = 1:area
        c = c + (rc(j,1) - row_center) ^ 2;
    end
    a = 0;
    for j = 1:area
        a = a + (rc(j,2) - col_center) ^ 2;
    end        
    b = 0;
    for j = 1:area
        b = b + 2 * (rc(j,1) - row_center) * (rc(j,2) - col_center);
    end 
    ori = (atan2(b, (a-c))) / 2;
    e = a * (sin(ori))^2 -...
        b * sin(ori) * cos(ori) +...
        c * (cos(ori))^2;
    arr = [arr, e, rad2deg(ori)];

    % 6.roundness
    % theta_1 -> E_min; theta_2 -> E_max
    % theta_1 + pi/2 = theta_2
    ori_2 = ori + (pi / 2);
    e_2 = a * (sin(ori_2))^2 -...
        b * sin(ori_2) * cos(ori_2) +...
        c * (cos(ori_2))^2;
    roundness = e / e_2;
    arr = [arr, roundness];
end

% This function is from demoMATLABTricksFun.m
function annotated_img = saveAnnotatedImg(fh)
figure(fh); 
set(fh, 'WindowStyle', 'normal');

img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 

annotated_img = frame.cdata;
end
