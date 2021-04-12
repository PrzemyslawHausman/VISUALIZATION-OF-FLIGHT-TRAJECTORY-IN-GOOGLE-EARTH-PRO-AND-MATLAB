clear
temp = regexp(fileread('date_text6.txt'), '\r?\n', 'split');
output = vertcat(temp{:});
n = size(output,1);
for i=1:n
data(i) = convertCharsToStrings(output(i,:));
end
save('date.mat', 'data');

