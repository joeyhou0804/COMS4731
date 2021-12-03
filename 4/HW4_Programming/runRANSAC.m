function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)

    [data, ~] = size(Xs);
    cur_id = 0;
    inliers_id = [];    
    
    for i = 1: ransac_n
        random_id = ceil(data .* rand(4,1));
        src_pts_nx2 = [];
        dest_pts_nx2 = [];
        for r = 1:4
            src_pts_nx2 = [src_pts_nx2;...
                Xs(random_id(r), 1), Xs(random_id(r), 2)];
            dest_pts_nx2 = [dest_pts_nx2;...
                Xd(random_id(r), 1), Xd(random_id(r), 2)];
        end
        H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2);
        
        inlier_no = 0;
        cur_inlier = [];
        for t = 1:data
            dest = H_3x3 * [Xs(t, 1); Xs(t, 2); 1];
            x = dest(1) / dest(3);
            y = dest(2) / dest(3);
            if sqrt((x - Xd(t, 1)) ^ 2 + (y - Xd(t, 2)) ^ 2) <= eps
                inlier_no = inlier_no + 1;
                cur_inlier = [cur_inlier, t];
            end
        end       
        if inlier_no > cur_id
            cur_id = inlier_no;
            inliers_id = cur_inlier;
            H = H_3x3;
        end
    end
end
