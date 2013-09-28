function jgit(varargin)
%JGIT Command line function for JGit4MATLAB.
%   A command line function to call JGit static methods.
%   Usage
%      JGIT <command> <args>    --> JGit.<command>(<args>)
%      JGIT help                --> help(JGit) or help JGit
%      JGIT help <command>      --> help(JGit.<command>) or help JGit.<command>
%
%   Examples:
%       >> jgit status
%       # On branch master
%       nothing to commit, working directory clean
%
%       >> jgit help status
%        JGit.status Return the status of the repository.
%           JGit.status(GITDIR) Specify the folder in which Git Repo resides.
%           JGit.status(GITDIR,FID) Output status to file identifier, FID.
%           JGit.status(GITDIR,FID,AMEND) Add "Initial commit" text to status.
%
%       >> jgit branch list [] ListMode ALL
%         gitCheckout
%       * master
%         origin/master
%
%       >> JGit.add({'foo.m','bar.m'}) % only strings used in commands
%
%       >> jgit commit all true message 'commit all tracked but not staged'

%% initialize and/or return JGit constants
if nargin==0
    try
        JGit %#ok<NOPRT>
    catch ME
        rethrow(ME)
    end
    return
end
%% command/arguments
cmd = varargin{1}; % command
% arguments if any
try
    argopts = varargin(2:end);
catch
    argopts = {};
end
%% help
if strcmp(cmd,'help')
    %% help
    fstr = 'JGit';
    if nargin==2
        fstr = [fstr,'.',varargin{2}];
    end
    help(fstr)
    return
end
%% brute force each command
switch lower(cmd)
    case 'status'
        %% status
        parsed_argopts = {};
    case 'add'
        %% add
        parsed_argopts = {};
        % update
        update = strcmp('-u',argopts) | strcmp('--update',argopts);
        if any(update)
            parsed_argopts = {'update',true};
            argopts(update) = [];
        end
        % filter other options and/or double-hyphen
        argopts = filterOpts(argopts);
        % filepatterns
        assert(~isempty(argopts),'jgit:add','Specify file patterns to add.')
        if numel(argopts)>1
            parsed_argopts = [{argopts},parsed_argopts]; % cell string
        else
            parsed_argopts = [argopts,parsed_argopts]; % char
        end
    case 'branch'
        parsed_argopts = parseBranch(argopts);
    otherwise
        error('jgit:noCommand','%s is not a jgit command',cmd)
end
try
    JGit.(cmd)(parsed_argopts{:})
catch ME
    rethrow(ME)
end
% end
end

function argopts = filterOpts(argopts)
%FILTEROPTS Filter out options from literal arguments.
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
argopts(strcmp('--',argopts)) = [];
end

function parsed_argopts = parseBranch(argopts)
%PARSEBRANCH Parse branch arguments and options.
parsed_argopts = {};
%% options
% force
force = strcmp('-f',argopts) | strcmp('--force',argopts);
% set-upstream mode
set_upstream = strcmp('--set-upstream',argopts);
track = strcmp('--track',argopts);
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
% pop upstream mode argopts
argopts(force) = [];
argopts(set_upstream) = [];
argopts(track) = [];
argopts(no_track) = [];
argopts(delbranch) = [];
argopts(forcedelete) = [];
argopts(move) = [];
argopts(remotes) = [];
argopts(listall) = [];
argopts(list) = [];
%% other options
% filter other options and/or double-hyphen
argopts = filterOpts(argopts);
% no argument or option checks - jgit checks args/opts
if any(move)
    %% rename branch
    % new and old branch names
    assert(~isempty(argopts),'jgit:branch','Specify new branch name.')
    assert(numel(argopts)==2,'jgit:branch','Specify old branch name.')
    parsed_argopts = {'rename',argopts(1),'oldNames',argopts(2)};
elseif any(delbranch) || any(forcedelete)
    %% delete branch
    parsed_argopts = {'delete',[]};
    % force delete
    if any(forcedelete)
        parsed_argopts = [parsed_argopts,'force',true];
    end
    % oldnames
    assert(~isempty(argopts),'jgit:branch','Specify branch(s) to delete.')
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
    assert(~isempty(argopts),'jgit:createBranch:noName', ...
        'Specify branch name to create.')
    parsed_argopts = ['create',argopts(1),parsed_argopts];
    % start-point
    if numel(argopts)>1
        parsed_argopts = [parsed_argopts,'startPoint',argopts(2)];
    end
end
end