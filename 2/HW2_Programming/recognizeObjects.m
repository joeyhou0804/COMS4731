function output_img = recognizeObjects(orig_img, labeled_img, obj_db)
    objects = [];
    [L, num] = bwlabel(labeled_img);
    for i = 1:num
        % helperFunction is defined in the last challenge
        arr = helperFunction(labeled_img, i);
        % save results in a 2d array
        objects = [objects; arr];
    end
    objects = objects.';
    db_num = size(obj_db, 2);
    
    match = [];
    error = 0.12;

    for i = 1:num
        for j = 1:db_num
            if (objects(6,i)/obj_db(6,j) <= 1 + error)...
                    && (objects(6,i)/obj_db(6,j) >= 1 - error)...
                    && (objects(4,i)/obj_db(4,j) <= 1 + error)...
                    && (objects(4,i)/obj_db(4,j) >= 1 - error)
                match = [match, i];
            end
        end
    end
    
    fh1 = figure;
    imshow(orig_img);

    hold on;    
    for m = 1:length(match) 
        % plot(x,y)
        plot(objects(3,match(m)), objects(2,match(m)),  'ws', 'MarkerFaceColor', [1 1 1]);
        cos_diff = cos(deg2rad(objects(5,match(m))));
        sin_diff = sin(deg2rad(objects(5,match(m))));
        line([objects(3,match(m))-50 * cos_diff objects(3,match(m))+50 * cos_diff],...
            [objects(2,match(m))-50 * sin_diff objects(2,match(m))+50 * sin_diff],...
            'LineWidth',2, 'Color', [0, 1, 0]);
    end
    output_img = saveAnnotatedImg(fh1);
    imshow(output_img);
end

% This is the helper function which is used here and in the last challenge
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
