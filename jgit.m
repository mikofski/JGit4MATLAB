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
try
    argopts = varargin{2:end};
catch
    argopts = {};
end
switch cmd
    case 'help'
        fstr = 'JGit';
        if nargin==2
            fstr = [fstr,'.',varargin{2}];
        end
        help(fstr)
    case 'add'
end
try
    %         JGit.(varargin{1})(varargin{2:end})
    JGit.(cmd)(argparse(cmd,argopts,GRAMMAR))
catch ME
    rethrow(ME)
end
% end
end

function argparse(cmd,argopts,grammar)
    argout = {};
    %% look for command
    commands = grammar(:,1);
    icmd = strcmpi(cmd,commands); % index of command
    if ~any(icmd)
        error('jgit:noCommand','%s is not a valid command',cmd)
    end
    cmdargs = grammar(icmd,2); % command args
    cmdopts = grammar(icmd,3); % command opts
    %% look for option terminator '--'
    lastopt = strcmp('--',argopts); % last option
    if any(lastopt)
        args = argopts(1:
        
    Nargs = numel(argopts); % number of args
    for n = 1:Nargs
        % check the first character
        if strcmp('-',argopts{n}(1))
            opt = strncmpi(
        end
    end
end

