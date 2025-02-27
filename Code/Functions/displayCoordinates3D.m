function txt = displayCoordinates3D(~,info)
    x = info.Position(1);
    y = info.Position(2);
    z = info.Position(3);
%     txt = ['(' num2str(round(x,2)) ', ' num2str(round(y,2)) ',' num2str(round(z,2)) ')'];
    txt = {['X:' num2str(round(x,2))];['Y:' num2str(round(y,2)) ];['Z:' num2str(round(z,2))]};
end
