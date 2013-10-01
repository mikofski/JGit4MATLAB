function parsed_argopts = parseBranch(argopts)
%PARSEBRANCH Parse branch arguments and options.
%   Copyright (c) 2013 Mark Mikofski
parsed_argopts = {};
%% options
% force
force = strcmp('-f',argopts) | strcmp('--force',argopts);
% set-upstream mode
set_upstream = strcmp('--set-upstream',argopts);
track = strcmp('-t',argopts) | strcmp('--track',argopts);
no_track = strcmp('--no-track',argopts);
% delete branch
delbranch = strcmp('-d',argopts) | strcmp('--delete',argopts);
% force delete
forcedelete = strcmp('-D',argopts);
% move
move = strcmp('-m',argopts) | strcmp('--move',argopts);
% remotes
remotes = strcmp('-r',argopts) | strcmp('--remotes',argopts);
% all
listall = strcmp('-a',argopts) | strcmp('--all',argopts);
% list
list = strcmp('--list',argopts);
%% pop argopts
argopts(force | set_upstream | track | no_track | delbranch | forcedelete | ...
    move | remotes | listall | list) = [];
%% other options
% filter other options and/or double-hyphen
argopts = filterOpts(argopts);
%% parse
% no argument or option checks - jgit checks args/opts
if any(move)
    %% rename branch
    % new and old branch names
    assert(~isempty(argopts),'jgit:parseBranch','Specify new branch name.')
    assert(numel(argopts)==2,'jgit:parseBranch','Specify old branch name.')
    parsed_argopts = {'rename',argopts(1),'oldNames',argopts(2)};
elseif any(delbranch) || any(forcedelete)
    %% delete branch
    parsed_argopts = {'delete',[]};
    % force delete
    if any(forcedelete)
        parsed_argopts = [parsed_argopts,'force',true];
    end
    % oldnames
    assert(~isempty(argopts),'jgit:parseBranch','Specify branch(s) to delete.')
    if numel(argopts)>1
        parsed_argopts = [parsed_argopts,'oldNames',{argopts}]; % cell string
    else
        parsed_argopts = [parsed_argopts,'oldNames',argopts]; % char
    end
elseif any(remotes) || any(listall) || any(list) || isempty(argopts)
    %% list branch
    parsed_argopts = {'list'};
    if any(listall)
        % all
        parsed_argopts = [parsed_argopts,{[]},'listMode','ALL'];
    elseif any(remotes)
        % remotes
        parsed_argopts = [parsed_argopts,{[]},'listMode','REMOTE'];
    end
else % if any(set_upstream) || any(track) || any(no_track) && ~isempty(argopts)
    %% create branch
    if any(set_upstream)
        % set-upstream
        parsed_argopts = {'upstreamMode','SET_UPSTREAM'};
    elseif any(track)
        % track
        parsed_argopts = {'upstreamMode','TRACK'};
    elseif any(no_track)
        % no-track
        parsed_argopts = {'upstreamMode','NO_TRACK'};
    end
    % force
    if any(force)
        parsed_argopts = [parsed_argopts,'force',true];
    end
    % branchname
    assert(~isempty(argopts),'jgit:parseBranch','Specify branch name to create.')
    parsed_argopts = ['create',argopts(1),parsed_argopts];
    % start-point
    if numel(argopts)>1
        parsed_argopts = [parsed_argopts,'startPoint',argopts(2)];
    end
end
end
