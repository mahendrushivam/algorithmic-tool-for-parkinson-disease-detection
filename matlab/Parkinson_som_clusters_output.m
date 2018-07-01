[filename directory_name] = uigetfile('*.xlsx', 'Select a file');
fullname = fullfile(directory_name, filename);
data = xlsread(fullname);
n=9;
[centres,U,obj_fcn] = fcm(data,n); 
M2=mean(data);
C=bsxfun(@rdivide,centres,M2);
cent=zeros(5875,1);
for i=1:5875
    
        cent(i,1)=1;
        max=U(1,i);
        for j=2:n
            if(U(j,i)>max)
                max=U(j,i);
                cent(i,1)=j;
            end
        end
end
data1=data;
x=data.';
net=selforgmap([2 3]);
[net,tr] = train(net,x); 
outputs=net(x);
outputs=outputs.';
centers = net.IW;
cluster_som=zeros(5875,1);
for i=1:5875
    for j=1:6
        if outputs(i,j)==1
            cluster_som(i,1)=j;
        end
    end
end


max1=zeros(n,1);
for i=1:5875
    for j=1:n
       if max1(j,1)<motor_UPDRS(i,1) && cent(i,1)==j 
           max1(j,1)=motor_UPDRS(i,1);
       end
    end
end

min1=zeros(n,1);
for i=1:n
    min1(i,1)=180;
end
for i=1:5875
    for j=1:n
       if min1(j,1)>motor_UPDRS(i,1) && cent(i,1)==j 
           min1(j,1)=motor_UPDRS(i,1);
       end
    end
end
    
 
for i=1:5875
    for j=1:16
        if data(i,j)~=0
        data(i,j)=data(i,j)*C(cent(i,1),j)+(1-((centroidbool(cluster_som(i,1),j)/data(i,j)))*rand())+((1-M2(1,j)/(data(i,j))*rand()));
        end
    end
end
trainset=data(1:3877,1:16);
testset=motor_UPDRS(1:3877);

mdl=fitcknn(trainset,testset,'NumNeighbors',3);
compmat=zeros(1998,1);
[label3,score,cost] = predict(mdl,data(3878:5875,1:16));
dist=zeros(1998,n);
for j=1:1998
  for i=1:n
    mid=((max1(i,1)-min1(i,1))/2);
    compmat(j,1)=1;
    if(label3(j,1)<=mid)
        dist(j,i)=abs(label3(j,1)-min1(i,1));
    else
         dist(j,i)=abs(label3(j,1)-max1(i,1));
    end
  end
end
k=0;
for i=1:1998
    min2=dist(i,1);
    for j=2:n
        if(min2<dist(i,j))
            min2=dist(i,j);
            compmat(i,1)=j;
        end
    end
    k=k+min2;
end
  
count=0;
for i=1:1998
    
    if compmat(i,1)==cent(i+3877,1)
      count=count+1;
    end
end

k=k/1998;
percent=(count*100)/1998;
Conf4 = confusionmat(compmat,cent(3878:5875));




