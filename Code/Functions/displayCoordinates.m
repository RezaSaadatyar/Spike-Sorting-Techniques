function txt = displayCoordinates(~,info)
    x = info.Position(1);
    y = info.Position(2);
%     txt = ['(' num2str(round(x,2)) ', ' num2str(round(y,2)) ')'];
    txt = {['X:' num2str(round(x,2))];['Y:' num2str(round(y,2))]};
end
