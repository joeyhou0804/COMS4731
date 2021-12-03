function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
    img_dir = [focal_stack_dir, '/*.jpg'];
    img_files = dir(img_dir);      
    n_files = length(img_files);
    
    rgb_stack = 0;
    gray_stack = 0;
    
    for i=1:n_files
       cur_name = [focal_stack_dir, '/', img_files(i).name];
       cur_img = imread(cur_name);
       gray_img = 0.299 * cur_img(:, :, 1) +...
           0.587 * cur_img(:, :, 2) +...
           0.114 * cur_img(:, :, 3);
       
       if rgb_stack == 0
           rgb_stack = cur_img;
       else
           rgb_stack = cat(3, rgb_stack, cur_img);
       end
       
       if gray_stack == 0
           gray_stack = gray_img;
       else
           gray_stack = cat(3, gray_stack, gray_img);
       end
    end
end
