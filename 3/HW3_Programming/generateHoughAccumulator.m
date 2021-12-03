function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
    [img_y, img_x] = size(img);
    theta_min = 0;
    theta_max = pi;
    rho_min = -sqrt(power(img_x,2) + power(img_y,2));
    rho_max = sqrt(power(img_x,2) + power(img_y,2));
    
    theta_increment = (theta_max - theta_min) / theta_num_bins;
    rho_increment = (rho_max - rho_min) / rho_num_bins;
    
    A = zeros(rho_num_bins, theta_num_bins);
    
    for y = 1:img_y
        for x = 1:img_x
            if img(y,x) == 255
                for t = 1:theta_num_bins
                    rho = -sqrt(power(x,2) + power(y,2))...
                        * sin(theta_min + theta_increment * (t-1)...
                        + atan(y/x) - (pi/2));
                    for r = 1:rho_num_bins
                        if rho > rho_min + rho_increment * (r-1)...
                                && rho <= rho_min + rho_increment * r
                            A(r,t) = A(r,t) + 1;
                        end
                    end
                end
            end
        end
    end
    
    hough_img = rescale(A, 0, 255);
    
end
