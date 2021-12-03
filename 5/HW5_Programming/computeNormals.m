function [normals, albedo_img] = ...
    computeNormals(light_dirs, img_cell, mask)
    [y_len,x_len] = size(mask);
    normals = zeros(y_len, x_len, 3);
    albedo_img = zeros(y_len, x_len);
    for i = 1:y_len
        for j = 1:x_len
            if mask(i,j) == 1
                % ==========================
                % Using all 5 bright sources
                % ==========================
                S_5x3 = light_dirs;
                I = double([img_cell{1}(i,j);img_cell{2}(i,j);...
                    img_cell{3}(i,j);img_cell{4}(i,j);...
                    img_cell{5}(i,j)]);
                N = S_5x3 \ I;
                albedo_img(i,j) = sqrt(N(1)^2 + N(2)^2 + N(3)^2);
                normals(i,j,:) = 1/albedo_img(i,j) * N.';
                % =========================
                % Using 3 brightest sources
                % =========================
%                 brightness = [];
%                 for t = 1:length(img_cell)
%                     brightness = [brightness, img_cell{t}(i,j)];
%                 end
%                 [bright, number] = maxk(brightness, 3);
%                 if bright(3) ~= 0
%                     S_3x3 = [light_dirs(number(1),:);...
%                         light_dirs(number(2),:);...
%                         light_dirs(number(3),:)];
%                     I = double([img_cell{number(1)}(i,j);...
%                         img_cell{number(2)}(i,j);...
%                         img_cell{number(3)}(i,j)]);
%                     N = S_3x3 \ I;
%                     albedo_img(i,j) = sqrt(N(1)^2 + N(2)^2 + N(3)^2);
%                     normals(i,j,:) = 1/albedo_img(i,j) * N.';
%                 end
            else
                normals(i,j,:) = [0,0,1];
                albedo_img(i,j) = 0;
            end
        end
    end
end
 
