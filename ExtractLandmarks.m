function [Endpoints, ShortRidges] = ExtractLandmarks(InputImage, RidgeLen)
    Endpoints = [];
    [BlackRows, BlackCols] = find(InputImage == 0);
    FirstRow = min(BlackRows);
    LastRow  = max(BlackRows);
    FirstCol = min(BlackCols);
    LastCol  = max(BlackCols);

    Neighbors = [-1,-1; -1,0; -1,1; 0,-1; 0,1; 1,-1; 1,0; 1,1];

    for Row = FirstRow+1 : LastRow-1
        for Col = FirstCol+1 : LastCol-1
            if InputImage(Row, Col) == 0
                BlackCount = 0;
                for k = 1:8
                    NeighborRow = Neighbors(k, 1);
                    NeighborCol = Neighbors(k, 2);
                    if InputImage(Row+NeighborRow, Col+NeighborCol) == 0
                        BlackCount = BlackCount + 1;
                    end
                end
                if BlackCount == 1
                    Endpoints = [Endpoints, [Col; Row]];
                end
            end
        end
    end

    ShortRidges = [];
    EndpointsCount = size(Endpoints, 2);
    used = false(1, EndpointsCount);

    for i = 1:EndpointsCount
        if used(i), continue; end

        StartRow = Endpoints(2, i);
        StartCol = Endpoints(1, i);
        path = TraceRidge(InputImage, StartRow, StartCol, RidgeLen);
        if isempty(path), continue; end

        EndRow = path(end, 1);
        EndCol = path(end, 2);
        for j = i+1:EndpointsCount
            if used(j), continue; end
            if Endpoints(2,j) == EndRow && Endpoints(1,j) == EndCol
                ShortRidges = [ShortRidges, [StartCol; StartRow; EndCol; EndRow]];
                used(i) = true;
                used(j) = true;
                break;
            end
        end
    end
end