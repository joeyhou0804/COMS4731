function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
    res = [];
    for i = 1:4
        s = [src_pts_nx2(i,1); src_pts_nx2(i,2); 1];
        d = H_3x3 * s;
        res = [res; d(1,1)/d(3,1) d(2,1)/d(3,1)];
    end
    dest_pts_nx2 = res;
end
