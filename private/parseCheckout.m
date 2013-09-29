function parsed_argopts = parseCheckout(argopts)
%PARSECHECKOUT Parse checkout arguments and options.
%   Copyright (c) 2013 Mark Mikofski
parsed_argopts = {};
%% options
% force
force = strcmp('-f',argopts) | strcmp('--force',argopts);
% newbranch
newbranch = strcmp('-b',argopts);
% force new branch
forcenew = strcmp('-B',argopts);
% stage for unmerged paths
ours = strcmp('--ours',argopts);
theirs = strcmp('--theirs',argopts);
% set upstream mode
track = strcmp('-t',argopts) | strcmp('--track',argopts);
no_track = strcmp('--no-track',argopts);
% paths
paths = strcmp('--',argopts);
% pop upstream mode argopts
argopts(force) = [];
argopts(newbranch) = [];
argopts(forcenew) = [];
argopts(ours) = [];
argopts(theirs) = [];
argopts(track) = [];
argopts(no_track) = [];
%% other options
% filter other options and/or double-hyphen
argopts = filterOpts(argopts,false);
% no argument or option checks - jgit checks args/opts
if any(newbranch) || any(forcenew)
    %% create
    if any(newbranch) || any(forcenew)
        parsed_argopts = [parsed_argopts,'createBranch',true];
    end
    if any(forcenew) || any(force)
        % force
        parsed_argopts = [parsed_argopts,'force',true];
    end
    % upstream mode
    if any(track)
        % track
        parsed_argopts = [parsed_argopts,'upstreamMode','TRACK'];
    elseif any(no_track)
        % no-track
        parsed_argopts = [parsed_argopts,'upstreamMode','NO_TRACK'];
    end
    % branchname
    assert(~isempty(argopts),'jgit:parseCheckout','Specify branch name to create.')
    parsed_argopts = [argopts(1),parsed_argopts];
    % start-point
    if numel(argopts)>1
        parsed_argopts = [parsed_argopts,'startPoint',argopts(2)];
    end
elseif any(paths)
    %% checkout paths
    parsed_argopts = {[]}; % startPoint specifies commit when checking out paths
    if any(ours)
        % stage ours
        parsed_argopts = [parsed_argopts,'stage','OURS'];
    elseif any(theirs)
        % stage theirs
        parsed_argopts = [parsed_argopts,'stage','THEIRS'];
    end
    % force
    if any(force)
        parsed_argopts = [parsed_argopts,'force',true];
    end
    % tree-ish
    assert(numel(argopts)>1,'jgit:parseCheckout','Specify path(s) to checkout.')
    if strcmp('--',argopts{2})
        parsed_argopts = [parsed_argopts,'startPoint',argopts(1)];
        argopts(1:2) = []; % pop tree-ish and '--'
    elseif strcmp('--',argopts{1})
        % no commit
        argopts(1) = []; % pop tree-ish and '--'
    else
        % ignore '--'
        argopts(strcmp('--',argopts)) = [];
        parsed_argopts = [parsed_argopts,'startPoint',argopts(1)];
        argopts(1) = []; % pop tree-ish
    end
    % paths
    assert(~isempty(argopts),'jgit:parseCheckout','Specify path(s) to checkout.')
    if numel(argopts)>1
        parsed_argopts = [parsed_argopts,'path',{argopts}]; % cell string
    else
        parsed_argopts = [parsed_argopts,'path',argopts]; % char
    end
else
    %% checkout commit-ish
    % force
    if any(force)
        parsed_argopts = [parsed_argopts,'force',true];
    end
    parsed_argopts = [argopts,parsed_argopts];
end
end
