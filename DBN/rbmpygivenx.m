function [class_prob,F]= rbmpygivenx(rbm,x,train_or_test)
%RBMPYGIVENX calculates class probabilities [p(y|x)]
% internal function
%
% Copyright (c) S�ren S�nderby july 2014
n_classes = size(rbm.d,1);
n_samples = size(x,1);

cwx = bsxfun(@plus,rbm.W*x',rbm.c);

% only apply dropout in training mode
if isequal(lower(train_or_test),'train') && rbm.dropout_hidden > 0
        cwx = cwx .* rbm.hidden_mask;
end

F = bsxfun(@plus, permute(rbm.U, [1 3 2]), cwx);
class_log_prob = zeros(n_samples,n_classes);
for y = 1:n_classes
    class_log_prob(:,y) =  sum( softplus(F(:,:,y)), 1)+ rbm.d(y);
end

%normalize probabilities
class_prob = exp(bsxfun(@minus, class_log_prob, max(class_log_prob, [], 2)));
class_prob = bsxfun(@rdivide, class_prob, sum(class_prob, 2));

end