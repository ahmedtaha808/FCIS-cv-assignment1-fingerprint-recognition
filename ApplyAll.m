function ApplyAll(ImagePath, RidgeLen, outputPath)

    if ~exist(outputPath, 'dir')
        mkdir(outputPath);
    end

    Img = imread(ImagePath);
    [RowsCount, ColsCount, ChannelsCount] = size(Img);
    fprintf('#Rows          = %d\n', RowsCount);
    fprintf('#Cols          = %d\n', ColsCount);
    fprintf('#Channels      = %d\n', ChannelsCount);

    [Endpoints, ShortRidges] = ExtractLandmarks(Img, RidgeLen);
    fprintf('#Endpoints     = %d\n', size(Endpoints, 2));
    fprintf('#ShortRidges   = %d\n', size(ShortRidges, 2));

    figure;
    subplot(1, 3, 1), imshow(Img), title('a. Preprocessed fingerprint ');

    subplot(1, 3, 2), imshow(Img), title('b. Extracted minutiae - endpoints');
    hold on;
    plot(Endpoints(1,:), Endpoints(2,:), 'r.', 'MarkerSize', 15);
    hold off;

    subplot(1, 3, 3), imshow(Img), title('c. Extracted minutiae - short ridges');
    hold on;
    for i = 1:size(ShortRidges, 2)
        x1 = ShortRidges(1, i);
        y1 = ShortRidges(2, i);
        path = TraceRidge(Img, y1, x1, RidgeLen);
        plot(path(:,2), path(:,1), 'b.', 'MarkerSize', 6);
    end
    hold off;
    
    EndPointsFilePath = strcat(outputPath, '/Endpoints.txt');
    EndPointsFile = fopen(EndPointsFilePath, 'w');
    for i = 1:size(Endpoints, 2)
        fprintf(EndPointsFile, '%d %d\n', Endpoints(1, i), Endpoints(2, i));
    end
    fclose(EndPointsFile);
    
    ShortRidgesFilePath = strcat(outputPath, '/ShortRidges.txt');
    ShortRidgesFile = fopen(ShortRidgesFilePath, 'w');
    for i = 1:size(ShortRidges, 2)
        fprintf(ShortRidgesFile, '%d %d %d %d\n', ShortRidges(1,i), ShortRidges(2,i), ShortRidges(3,i), ShortRidges(4,i));
    end
    fclose(ShortRidgesFile);
end
