function [ data_final ] = stringArray( varargin )
%function varlist(varargin)
 %nargin
 max = 0;
 for i=1:nargin
    if max < length(varargin{i})
        max = length(varargin{i});
    end
 end
 data = strings(nargin, 1);
 for j=1:nargin
    curr = length(varargin{j});
    data(j,1:curr) = varargin{j};
    for o=1:max-curr
        data(j,curr+o) = ' ';
    end
 end
data_final = data(:,1);
end

