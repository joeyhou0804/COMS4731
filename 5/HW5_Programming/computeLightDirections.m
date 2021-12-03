function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)
    res = [];
    for i = 1:length(img_cell)
        max_bright = max(max(img_cell{i}));
        [y,x] = find(img_cell{i} == max_bright);
        x_center = sum(x) / length(x);
        y_center = sum(y) / length(y);
        normal = computeNormalVector(center, radius, x_center, y_center);
        res = [res; double([max_bright, max_bright, max_bright]) .* normal];
    end
    light_dirs_5x3 = res;
end

function normal = computeNormalVector(center, radius, x_coor, y_coor)
    x = x_coor - center(1);
    y = y_coor - center(2);
    z = sqrt(radius^2 - x^2 - y^2);
    normal = [1/radius, 1/radius, 1/radius] .* [x, y, -z];
end
