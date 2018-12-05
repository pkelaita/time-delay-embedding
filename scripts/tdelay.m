close all;

LOAD = true;

% Load segmented time series data
if (LOAD)
    comps = load('vars/comps.mat');
    segs = load('vars/segs.mat');
    comps = comps.comps;
    segs = segs.segs;
    segMap = containers.Map(comps, segs);
end

% Choose a company
comp_data = segMap('MSFT');

% Create matrix parametrized by date
nums = datenum(comp_data.date);
m = min(nums);
comp_data.date = nums - m;
comp_data = sortrows(comp_data, 'date');
comp_data(:,1:4) = []; % maybe fill in missing times?
A = table2array(comp_data);

A(isnan(A)) = 0; % maybe infer values

% Time-delay embed
HROWS = 8;

x = A(:,1);
y = A(:,2);
z = A(:,3);
t = (1:length(x)).';
n = length(t) - HROWS;

H = zeros(HROWS, n+1);
for i = 1:HROWS
    H(i,:) = x(i:n+i).';
end

[u,s,v] = svd(H, 'econ');

figure(3), plot(100*diag(s)/sum(diag(s)),'ro','Linewidth',[3])
grid on
%figure(4), plot(u(:,1:5),'Linewidth',[2])

figure(5)
plot3(v(:,1),v(:,2),v(:,3),'Linewidth',[2]), grid on

figure(6), plot(600*v(:,4),'Linewidth',[2]), grid on
hold on
plot(x(1:n+1))
hold off


