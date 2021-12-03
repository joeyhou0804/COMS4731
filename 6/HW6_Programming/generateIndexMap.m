function index_map = generateIndexMap(gray_stack, w_size)
    h = fspecial('laplacian');
    [row, col, len] = size(gray_stack);
    all_measure = zeros(row, col);
    index_map = zeros(row, col);
    
    img_stack = [];
    for t = 1:len
        img = imfilter(gray_stack(:, :, t), h);
        if t == 1
            img_stack = img;
        else
            img_stack = cat(3, img_stack, img);
        end
    end
    int_img = integralImage(img_stack, w_size);   
    
    for t = 1:len
        focus_measure = zeros(row, col);

        for i = 1:row
            for j = 1:col
                focus_measure(i, j) = int_img(i + 2 * w_size + 1, j + 2 * w_size + 1,t)...
                    - int_img(i, j + 2 * w_size + 1,t)...
                    - int_img(i + 2 * w_size + 1, j,t)...
                    + int_img(i, j,t);
                if focus_measure(i,j) > all_measure(i,j)
                    all_measure(i,j) = focus_measure(i,j);
                    index_map(i,j) = t;
                end
            end
        end
    end
end

function int_img = integralImage(img_stack, w_size)
    [row, col, len] = size(img_stack);
    padding = w_size + 1;
    
    int_img_1 = zeros(padding, col + padding * 2, len);
    int_img_2 = cat(2, zeros(row, padding, len), double(img_stack), zeros(row, padding, len));
    
    int_img = cat(1, int_img_1, int_img_2, int_img_1);
    
    [row, col, ~] = size(int_img);
    
    for i = 2:row
        int_img(i,1,:) = int_img(i,1,:) + int_img(i-1,1,:);
    end
    
    for j = 2:col
        int_img(1,j,:) = int_img(1,j,:) + int_img(1,j-1,:);
    end
    
    for i = 2:row
        for j = 2:col
            int_img(i,j,:) = int_img(i,j,:) + int_img(i-1,j,:)...
                + int_img(i,j-1,:) - int_img(i-1,j-1,:);
        end
    end
end

    
