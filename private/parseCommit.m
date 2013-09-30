function parsed_argopts = parseCommit(argopts)
%PARSECOMMIT Parse commit arguments and options.
%   Copyright (c) 2013 Mark Mikofski
parsed_argopts = {};
%% options
% all
allcommit = strcmp('-a',argopts) | strcmp('--all',argopts);
% amend
amend = strcmp('--amend',argopts);
% message
message = strcmp('-m',argopts) | strcmp('--message',argopts);
end

