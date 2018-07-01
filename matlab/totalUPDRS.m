[filename directory_name] = uigetfile('*.xlsx', 'Select a file');
fullname = fullfile(directory_name, filename);
data = xlsread(fullname);
op=zeros(5875,1);
for i=1:5875
    if total_UPDRS(i,1)>=0 && total_UPDRS(i,1)<=34
        op(i,1)=1;
    end
    if total_UPDRS(i,1)>34 && total_UPDRS(i,1)<=69
        op(i,1)=2;
    end
    if total_UPDRS(i,1)>69 && total_UPDRS(i,1)<=104
        op(i,1)=3;
    end
end
mdl=fitcknn(data(1:3456,1:end-1),op(1:3456),'NumNeighbors',3);
[label3,score,cost] = predict(mdl,data(3457:5875,1:end-1));
Conf5 = confusionmat(label3,op(3457:5875));
results = multisvm(data(1:3456,1:end-1),op(1:3456), data(3456:5875,1:end-1));
Conf4 = confusionmat(results,op(3456:5875));