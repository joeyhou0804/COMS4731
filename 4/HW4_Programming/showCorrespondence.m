function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)
    [~, X, ~] = size(orig_img);
    [points, ~] = size(src_pts_nx2);

    fh = figure;
    imshow([orig_img warped_img]);

    hold on;
    for i = 1:points
        line([src_pts_nx2(i,1), X + dest_pts_nx2(i,1)],...
            [src_pts_nx2(i,2), dest_pts_nx2(i,2)],...
            'LineWidth', 2, 'Color', [1, 0, 0]);
    end
    
    result_img = saveAnnotatedImg(fh);
    imshow(result_img);
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