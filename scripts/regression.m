var = load('vars/assets.mat');
data = var.assets(:,[2 5 6 7]);

% y = F(x1, x2)
x1 = table2array(data(:,2)); % PRICE
x2 = table2array(data(:,3)); % VOLUME
y = table2array(data(:,4)); % RETURN

% Differentiate - this method can be improved
dt = 1;
n=length(x1);
for j=2:n-1
  x1dot(j-1)=(x1(j+1)-x1(j-1))/(2*dt);
  x2dot(j-1)=(x2(j+1)-x2(j-1))/(2*dt);
end

x1s=x1(2:n-1);
x2s=x2(2:n-1);
theta=[x1s x2s x1s.^2 x1s.*x2s x2s.^2 x1s.^3 (x2s.^2).*x1s x2s.^3];

xi1=theta\x1dot.';
xi2=theta\x2dot.';

subplot(2,1,1), bar(xi1)
subplot(2,1,2), bar(xi2)