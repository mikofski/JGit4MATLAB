function parsed_argopts = parseCheckout(argopts)
%PARSECHECKOUT Parse checkout arguments and options.
%   Copyright (c) 2013 Mark Mikofski
parsed_argopts = {};
%% options
dictionary = { ...
    'force',{'-f','--force'},true; ...
    'newBranch',{'-b'},true; ...
    'forceNew',{'-B'},true; ...
    'ours',{'--ours'},true; ...
    'theirs',{'--theirs'},true; ...
    'set_upstream',{'--set-upstream'},true; ...
    'track',{'-t','--track'},true; ...
    'no_track',{'--no-track'},true; ...
    };
[options,argopts] = parseOpts(argopts,dictionary);
% paths
paths = strcmp('--',argopts);
%% other options
% filter other options and/or double-hyphen
argopts = filterOpts(argopts,false);
%% parse
% no argument or option checks - jgit checks args/opts
if options(1).('newBranch') || options(1).('forceNew')
    %% create
    if options(1).('newBranch') || options(1).('forceNew')
        parsed_argopts = [parsed_argopts,'createBranch',true];
    end
    if options(1).('forceNew') || options(1).('force')
        % force
        parsed_argopts = [parsed_argopts,'force',true];
    end
    % upstream mode
    if options(1).('set_upstream')
        % set-upstream
        parsed_argopts = [parsed_argopts,'upstreamMode','SET_UPSTREAM'];
    elseif options(1).('track')
        % track
        parsed_argopts = [parsed_argopts,'upstreamMode','TRACK'];
    elseif options(1).('no_track')
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
    if options(1).('ours')
        % stage ours
        parsed_argopts = [parsed_argopts,'stage','OURS'];
    elseif options(1).('theirs')
        % stage theirs
        parsed_argopts = [parsed_argopts,'stage','THEIRS'];
    end
    % force
    if options(1).('force')
        parsed_argopts = [parsed_argopts,'force',true];
    end
    % tree-ish
    assert(numel(argopts)>1,'jgit:parseCheckout','Specify path(s) to checkout.')
    if strcmp('--',argopts{1})
        % no commit
        argopts(1) = []; % pop '--'
    else
        % ignore '--', assume 1st arg is tree-ish, other args are paths
        argopts(strcmp('--',argopts)) = []; % pop '--'
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
    if options(1).('force')
        parsed_argopts = [parsed_argopts,'force',true];
    end
    parsed_argopts = [argopts,parsed_argopts];
end
end
