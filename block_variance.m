function block = block_variance(block)
assert(isa(block, 'overlap_block'), ['input should be an overlapping_block' ...
    '\nis a: %s'], class(block));
% find variance of the block:

N = numel(block.pixel{1});
f_mean = @(pixel) sum(sum(pixel))/N;
f_variance = @(pixel, mean) sum(sum((pixel-mean)));
row = @(A) reshape(A, 1, []);

block.avg_gray =  row((cellfun(f_mean, block.pixel)));
block.variance =  row( cellfun(f_variance, block.pixel, ...
    num2cell(block.avg_gray)));
end