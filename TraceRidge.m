function path = TraceRidge(InputImage, StartRow, StartCol, maxLen)
    path = [StartRow, StartCol];
    visited = false(size(InputImage));
    visited(StartRow, StartCol) = true;
    r = StartRow;
    c = StartCol;

    Neighbors = [-1,-1; -1,0; -1,1; 0,-1; 0,1; 1,-1; 1,0; 1,1];

    for step = 1:maxLen
        neighbors = [];
        for k = 1:8
            NeighborRow = r + Neighbors(k, 1);
            NeighborCol = c + Neighbors(k, 2);
            if NeighborRow < 1 || NeighborRow > size(InputImage,1) || NeighborCol < 1 || NeighborCol > size(InputImage,2)
                continue;
            end
            if InputImage(NeighborRow, NeighborCol) == 0 && ~visited(NeighborRow, NeighborCol)
                neighbors = [neighbors; NeighborRow, NeighborCol];
            end
        end

        if size(neighbors, 1) > 1   % bifurcation
            path = [];
            return;
        end
        if size(neighbors, 1) == 0  % endpoint
            break;
        end

        % else move to it
        NeighborRow = neighbors(1, 1);
        NeighborCol = neighbors(1, 2);
        path = [path; NeighborRow, NeighborCol];
        visited(NeighborRow, NeighborCol) = true;
        r = NeighborRow;
        c = NeighborCol;
    end
end