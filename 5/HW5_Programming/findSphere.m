function [center, radius] = findSphere(img)
    imgBW = im2bw(img, 0.1);
    stats = regionprops('table',imgBW,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
    center = stats.Centroid;
    radius = mean([stats.MajorAxisLength ...
        stats.MinorAxisLength],2) / 2;
end
