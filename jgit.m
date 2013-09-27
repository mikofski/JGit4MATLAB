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

GRAMMAR = {'add',{'files'},{'update'}; ...
    'branch',{'cmd','newName'},{'force','startPoint','upstreamMode','listMode','oldNames'}; ...
    'checkout',{},{}; ...
    'clone',{},{}; ...
    'commit',{},{}; ...
    'diff',{},{}; ...
    'fetch',{},{}; ...
    'init',{},{}; ...
    'log',{},{}; ...
    'merge',{},{}; ...
    'pull',{},{}; ...
    'push',{},{}; ...
    'status',{},{}};
if nargin==0
    try
        JGit %#ok<NOPRT>
    catch ME
        rethrow(ME)
    end
    return
end
% elseif strcmpi(varargin{1},'help')
%     fstr = 'JGit';
%     if nargin==2
%         fstr = [fstr,'.',varargin{2}];
%     end
%     help(fstr)
% else
cmd = varargin{1}; % command
% arguments if any
try
    argopts = varargin{2:end};
catch
    argopts = {};
end
% find option terminator '--' if exists
if ~isempty(argopts)    
    lastopt = strcmp('--',argopts); % last option
    % split options and args by terminator
    if any(lastopt)
        lastopt = find(lastopt); % index of last option
        % last option is last argopt
        if lastopt==numel(argopts)
            args = {};
        else
            args = argopts(lastopt+1:end);
        end
        % last option is first argopt
        if lastopt==1
            opts = 0;
        else
            opts = argopts(1:lastopt-1);
        end
    end
    % parse options
    parsed_options = opts; % parsed args
    Nopts = numel(opts); % initial number of options
    for o = 1:Nopts
        % short options
        isshort = strncmp('-',o,1); % short options
        if isshort
            if length(o)==2
                okey = o;oval = true; % boolean options
            elseif length(o)>2
                okey = o(1:2); % option key-value pairs
                try
                    oval = str2double(o(3:end));
                catch
                    oval = o(3:end);
                end
            else
                error('jgit:parse','"-" is not a valid jgit option or argument.')
            end
        parsed_options = [argopts, okey, oval];
        end
    end
    
end
switch cmd
    case 'help'
        fstr = 'JGit';
        if nargin==2
            fstr = [fstr,'.',varargin{2}];
        end
        help(fstr)
    case 'add'
        % look for update option
        update = strcmpi('-u',argopts) | strcmpi('--update',argopts);
        if any(update)
            parsed_argopts = {'update','true'};
            argopts(update) = [];
        end
        options = strncmp('-',argopts,1) | strncmp('--',argopts,2); % options
        if any(options)
            argopts(options) = [];
        end
        parsed_argopts = [argoupts,parsed_argopts];
    otherwise
        error('jgit:noCommand','%s is not a jgit command',cmd)
end
try
    %         JGit.(varargin{1})(varargin{2:end})
    JGit.(cmd)(argparse(cmd,argopts,GRAMMAR))
catch ME
    rethrow(ME)
end
% end
end

% short options
%     short = strncmp('-',opts,1); % short options
%     long = strncmp('--',opts,2); % long options
%     Nopts = sum(short)+sum(long); % number of options

% function argparse(cmd,argopts,grammar)
%     argout = {};
%     %% look for command
%     commands = grammar(:,1);
%     icmd = strcmpi(cmd,commands); % index of command
%     if ~any(icmd)
%         error('jgit:noCommand','%s is not a valid command',cmd)
%     end
%     cmdargs = grammar(icmd,2); % command args
%     cmdopts = grammar(icmd,3); % command opts
%     %% look for option terminator '--'
%     lastopt = strcmp('--',argopts); % last option
%     if any(lastopt)
%         args = argopts(1:find(lastopt));
%     end
%     Nargs = numel(argopts); % number of args
%     for n = 1:Nargs
%         % check the first character
%         if strcmp('-',argopts{n}(1))
%             opt = strncmpi()
%         end
%     end
% end

