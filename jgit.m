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
    argopts = varargin{2:end};
catch
    argopts = {};
end
%% brute force each command
switch cmd.lower
    case 'help'
        %% help
        fstr = 'JGit';
        if nargin==2
            fstr = [fstr,'.',varargin{2}];
        end
        help(fstr)
    case 'add'
        %% add
        parsed_argopts = {};
        % look for update option
        update = strcmpi('-u',argopts) | strcmpi('--update',argopts);
        if any(update)
            parsed_argopts = {'update',true};
            argopts(update) = [];
        end
        % look for any more options or option-terminatore
        options = strncmp('-',argopts,1) | strncmp('--',argopts,2); % options
        if any(options)
            argopts(options) = [];
        end
        % whatever is left must be filepatterns
        assert(~isempty(argopts),'jgit:add','Specify file patterns to add.')
        parsed_argopts = [argopts,parsed_argopts];
    case 'branch'
        %% branch
        parsed_argopts = {};
        % look for force
        force = strcmpi('-f',argopts) | strcmpi('--force',argopts);
        % look for set-upstream mode
        set_upstream = strcmpi('--set-upstream',argopts);
        track = strcmpi('--track',argopts);
        no_track = strcmpi('--no-track',argopts);
        % look for delete
        delbranch = strcmpi('-d',argopts) | strcmpi('--delete',argopts);
        % look for force delete
        forcedelete = strcmpi('-D',argopts);
        % look for move
        move = strcmpi('-m',argopts) | strcmpi('--move',argopts);
        % check for ambiguous upstream mode
        if sum(set_upstream | track | no_track)>1
            error('jgit:setupstream', ...
                'Choose only one upstream mode: "--set-upstream", "track" or "no-track".')
        elseif sum(set_upstream | track | no_track)==1
            % create branch
            if any(set_upstream)
                % set-upstream
                parsed_argopts = {'upstreamMode','SET_UPSTREAM'};
                argopts(set_upstream) = [];
            elseif any(track)
                % track
                parsed_argopts = {'upstreamMode','TRACK'};
                argopts(set_upstream) = [];
            elseif any(no_track)
                % no-track
                parsed_argopts = {'upstreamMode','NO_TRACK'};
                argopts(set_upstream) = [];
            end
            % force
            if any(force)
                parsed_argopts = [parsed_argopts,'force',true];
                argopts(set_upstream) = [];
            end
            % look for any more options or option-terminatore
            options = strncmp('-',argopts,1) | strncmp('--',argopts,2); % options
            if any(options)
                argopts(options) = [];
            end
            % whatever is left must be branchname and start-point
            assert(~isempty(argopts),'jgit:branch','Specify branchname to create.')
            parsed_argopts = ['create',argopts(1),parsed_argopts];
            if numel(argopts)==2
                parsed_argopts = [parsed_argopts,'startPoint',argopts(2)];
            end
        elseif any(move)
            % move
            argopts(move) = [];
            % look for any more options or option-terminatore
            options = strncmp('-',argopts,1) | strncmp('--',argopts,2); % options
            if any(options)
                argopts(options) = [];
            end
            % whatever is left must be branchname and oldname
            assert(~isempty(argopts),'jgit:branch','Specify branch new name.')
            assert(numel(argopts)==2,'jgit:branch','Specify branch old name.')
            parsed_argopts = {'rename',argopts(1),'oldNames',argopts(2)};
        elseif any(delbranch) || any(forcedelete)
            % delete
            if any(delbranch)
                parsed_argopts = {'delete',{[]},};
                argopts(delbranch) = [];
            end
            % force delete
            if any(forcedelete)
                parsed_argopts = [parsed_argopts,'force',true];
                argopts(forcedelete) = [];
            end
            % look for any more options or option-terminatore
            options = strncmp('-',argopts,1) | strncmp('--',argopts,2); % options
            if any(options)
                argopts(options) = [];
            end
            % whatever is left must be oldnames
            assert(~isempty(argopts),'jgit:branch','Specify branch(s) to delete.')
            parsed_argopts = [parsed_argopts,'startPoint',argopts];
        end
    otherwise
        error('jgit:noCommand','%s is not a jgit command',cmd)
end
try
    JGit.(cmd)(parsed_argopts)
catch ME
    rethrow(ME)
end
% end
end
