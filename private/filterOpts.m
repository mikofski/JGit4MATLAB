function argopts = filterOpts(argopts, pop)
%FILTEROPTS Filter out options from literal arguments.
%   Copyright (c) 2013 Mark Mikofski
if nargin<2 || isempty(pop)
    pop = true;
end
%% other options
% double-hyphen is used to indicate the last option,
% arguments after lastopt are interpreted literaly.
lastopt = ~cumsum(strcmp('--',argopts)); % last option
options = strncmp('-',argopts(lastopt),1) | strncmp('--',argopts(lastopt),2);
if any(options)
    warning('jgit:unsupportedOption','Unsupported options.')
    unsupported_options = argopts(options);
    fprintf(2,'\t%s\n',unsupported_options{:});
    argopts(options) = [];
end
%% pop double-hyphen
if pop,argopts(strcmp('--',argopts)) = [];end
end
