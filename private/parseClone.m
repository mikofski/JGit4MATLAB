function parsed_argopts = parseClone(argopts)
%PARSEBRANCH Parse clone arguments and options.
%   Copyright (c) 2013 Mark Mikofski
parsed_argopts = {};
%% options
% bare
bare = strcmp('--bare',argopts);
% remote name [origin]
origin = strcmp('-o|--origin',argopts);
% branch
branch = strcmp('-b',argopts) | strcmp('--branch',argopts);
% clone submodules recursively
recursive = strcmp('--recursive',argopts) | strcmp('--recurse-submodules',argopts);
% branches to clone
single_branch = strcmp('--single-branch',argopts);
no_single_branch = strcmp('--no-single-branch',argopts);
% pop upstream mode argopts
argopts(bare) = [];
argopts(origin) = [];
argopts(branch) = [];
argopts(recursive) = [];

%% other options
% filter other options and/or double-hyphen
argopts = filterOpts(argopts);
% no argument or option checks - jgit checks args/opts

