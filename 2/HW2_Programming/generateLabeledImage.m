function labeled_img = generateLabeledImage(gray_img, threshold)
    bw_img = im2bw(gray_img, threshold);
    % number of dilation/erosion
    n = 1;    
    processed_img = bwmorph(bw_img, 'dilate', n);    
    processed_img = bwmorph(processed_img, 'erode', n);
    labeled_img = bwlabel(processed_img);
end


