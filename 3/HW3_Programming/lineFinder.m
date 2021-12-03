function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
% generateHoughAccumulator(imread(['edge_hough_1.png']), 50, 100)
    [img_y, img_x] = size(orig_img);
    [rho_num_bins, theta_num_bins] = size(hough_img);
    theta_min = 0;
    theta_max = pi;
    rho_min = -sqrt(power(img_x,2) + power(img_y,2));
    rho_max = sqrt(power(img_x,2) + power(img_y,2));
    
    t_error = 6;
    r_error = 6;
    
    theta_increment = (theta_max - theta_min) / theta_num_bins;
    rho_increment = (rho_max - rho_min) / rho_num_bins; 
    
    lines = [];
    
    for r = 1:rho_num_bins
        for t = 1:theta_num_bins
            if hough_img(r,t) >= hough_threshold
                exist = false;
                
                for i = 1:size(lines,1)
                    if r <= lines(i,1) + r_error...
                            && r >= lines(i,1) - r_error...
                            && t <= lines(i,2) + t_error...
                            && t >= lines(i,2) - t_error
                        if hough_img(r,t) > hough_img(lines(i,1), lines(i,2))
                            lines(i,1) = r;
                            lines(i,2) = t;
                        else
                            exist = true;
                        end
                    end
                end
                
                if exist
                    continue
                end
                
                lines = [lines; r, t];
            end
        end
    end
    
    fh = figure;
    imshow(orig_img);

    hold on;    
    for i = 1:size(lines, 1)
        r = lines(i,1);
        t = lines(i,2);
        rho = rho_min + rho_increment * (r-1);
        theta = theta_min + theta_increment * (t-1);
        if tan(theta) < 0
            line([rho / cos(theta), 0],...
                [0, -rho / sin(theta)],...
                'LineWidth',1, 'Color', [0, 1, 0]);
        else
            line([img_x, 0],...
               [(-rho + img_x * cos(theta))/sin(theta), -rho / sin(theta)],...
               'LineWidth',1, 'Color', [0, 1, 0]);
        end                
    end
    
    line_detected_img = saveAnnotatedImg(fh);
    imshow(line_detected_img);
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