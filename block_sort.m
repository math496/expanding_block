    function [block] = block_sort(block, varargin)
% sorts lexigraphically blocks by average gray value or variance
% input: block_sort(block, 'variance') sorts by variance
% note: no for loops! pretty neat, huh?
%% INPUT HANDLING

SORT_BY_VARIANCE = 0;
REMOVE_LOW_VARIANCE_BLOCKS = 0;
if nargin > 1;
    for n = 1:length(varargin)
        if strcmp(varargin{n}, 'variance')
            SORT_BY_VARIANCE = 1;
            REMOVE_LOW_VARIANCE_BLOCKS = 1;
        end
    end
end
        
assert(isa(block, 'overlap_block'), ['first input is a %s'...
    'must be a BLOCK object'], class(block))
row = @(t) reshape(t, [], 1);

N = numel(block.pixel);
pixel = row(block.pixel);
avg_gray = row(block.avg_gray);
variance = row(block.variance);
x = row(block.x);
y = row(block.y);
key = row(1:N);
%% SORT
if SORT_BY_VARIANCE
    SORTED = sortrows([variance, y, x, key, avg_gray]);
    block.variance = SORTED(:, 1);
    block.avg_gray = SORTED(:, 5);
else
    SORTED = sortrows([avg_gray, y, x, key, variance]);
    block.avg_gray = SORTED(:, 1);
    block.variance = SORTED(:, 5);
end

block.x = SORTED(:, 3);
block.y = SORTED(:, 2);
key = SORTED(:, 4);
block.pixel = pixel(key);

%% remove elements with nonzero variance
if REMOVE_LOW_VARIANCE_BLOCKS
    blockSize = numel(block.pixel{1});
    var_not_tiny = find(block.variance > blockSize);
    block.variance = block.variance(var_not_tiny);
    block.x = block.x(var_not_tiny);
    block.y = block.y(var_not_tiny);
    block.pixel = block.pixel(var_not_tiny);
    block.avg_gray = block.avg_gray(var_not_tiny);
end