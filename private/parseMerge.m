function parsed_argopts = parseMerge(argopts)
%PARSEMERGE Parse merge arguments and options.
%   Copyright (c) 2013 Mark Mikofski
parsed_argopts = {};
%% options
dictionary = { ...
    'dryRun',{'--dry-run'},true; ...
    'prune',{'-p','--prune'},true; ...
    'tags',{'-t','--tags'},true;
    'noTags',{'-n','--no-tags'},true};
[options,argopts] = parseOpts(argopts,dictionary);
%% other options
% filter other options and/or double-hyphen
[argopts] = filterOpts(argopts);
%% parse
% no argument or option checks - jgit checks args/opts
% setDryRun