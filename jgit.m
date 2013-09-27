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

if nargin==0
    try
        JGit %#ok<NOPRT>
    catch ME
        rethrow(ME)
    end
elseif strcmpi(varargin{1},'help')
    fstr = 'JGit';
    if nargin==2
        fstr = [fstr,'.',varargin{2}];
    end
    help(fstr)
else
    bools = [false,strcmpi('true',varargin(2:end))];
    [varargin{bools}] = deal(true);
    bools = [false,strcmpi('false',varargin(2:end))];
    [varargin{bools}] = deal(false);
    numbers = [NaN,str2double(varargin(2:end))];
    varargin(~isnan(numbers)) = num2cell(numbers(~isnan(numbers)));
    try
        JGit.(varargin{1})(varargin{2:end})
    catch ME
        rethrow(ME)
    end
end
end

