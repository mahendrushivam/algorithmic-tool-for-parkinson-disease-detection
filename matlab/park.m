[filename directory_name] = uigetfile('*.xlsx', 'Select a file');
fullname = fullfile(directory_name, filename);
data = xlsread(fullname);
data1=data(:,[1 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 ]);
n=2;
[centres,U,obj_fcn] = fcm(data1,n); 
M2=mean(data1);
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
data2=data1;
x=data2.';
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

for i=1:5875
    for j=3:19
        if data1(i,j)~=0
        data1(i,j)=data1(i,j)*C(cent(i,1),j)+(1-((centroidbool(cluster_som(i,1),j)/data1(i,j)))*rand())+((1-M2(1,j)/(data1(i,j))*rand()));
        end
        
    end
end
