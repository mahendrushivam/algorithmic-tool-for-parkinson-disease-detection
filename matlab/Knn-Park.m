[filename directory_name] = uigetfile('*.xlsx', 'Select a file');
fullname = fullfile(directory_name, filename);
data = xlsread(fullname);
[centres,U] = fcm(data,2);
M=mean(data);
C=bsxfun(@rdivide,centres,M);
D=zeros(2,22);
for ij=1:2
   im=1;
   for ii=1:23
       if ii~=17
         D(ij,im)=C(ij,ii);
         im=im+1;
       end
    end
end
data2=zeros(195,22);
for ii = 1:195
       ik=1;
       for ij =1:23
           if ij~=17
            data2(ii,ik)=(data(ii,ij)*D(1,ik))+ (data(ii,ij)*D(2,ik));
            ik=ik+1;
           end
            
       end
    
end
boxplot(data2);
trainset=data2(1:149,:);
testset=status(1:149);

mdl=fitcknn(trainset,testset,'NumNeighbors',6,'Standardize',1);
[label2,score,cost] = predict(mdl,data2(149:195,:));
Conf4 = confusionmat(label2,status(149:195));




    
