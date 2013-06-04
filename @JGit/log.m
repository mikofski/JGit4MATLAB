function log(varargin)
%JGIT.LOG Show the commit log.
%   JGIT.LOG(PARAMETER,VALUE,...) uses any combination of the following
%   PARAMETER, VALUE pairs.
%   'maxCount' <integer> [] Maximum count of commit logs to show.
%   'skip' <integer> [] Number of commits logs to skip.
%   'since' <char> [] Show log of newer commits since this commit.
%   'until' <char> [] Show log of older commits until this commit.
%   'path' <char> [] Show log of files on specified path.
%   'gitDir' <char> [PWD] Specify the folder in which Git Repo resides.
%
%   For more information see also
%   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-log.html">Git Log Documentation</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/LogCommand.html">JGit Git API Class LogCommand</a>
%
%   Example:
%       JGIT.LOG('since','HEAD~5') % show last 5 commits
%
%   See also JGIT
%
%   Version 0.3 - Chameleon Release
%   2013-04-22 Mark Mikofski
%   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>

%% check inputs
p = inputParser;
p.addParamValue('maxCount',0,@(x)validateattributes(x,{'numeric'},{'integer', ...
    'nonnegative','scalar'}))
p.addParamValue('skip',0,@(x)validateattributes(x,{'numeric'},{'integer', ...
    'nonnegative','scalar'}))
p.addParamValue('since','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('until','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('path','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('gitDir',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(varargin{:})
gitDir = p.Results.gitDir;
gitAPI = JGit.getGitAPI(gitDir);
logCMD = gitAPI.log;
%% set max count
if p.Results.maxCount>0
    logCMD.setMaxCount(p.Results.maxCount);
end
%% set skip
if p.Results.skip>0
    logCMD.setSkip(p.Results.skip);
end
%% set since and until
repo = gitAPI.getRepository;
if ~isempty(p.Results.since) && ~isempty(p.Results.until)
    since = repo.resolve(p.Results.since);
    until = repo.resolve(p.Results.until);
    logCMD.addRange(since,until);
elseif ~isempty(p.Results.since) && isempty(p.Results.until)
    since = repo.resolve(p.Results.since);
    HEAD = repo.resolve('HEAD');
    logCMD.addRange(since,HEAD);
elseif isempty(p.Results.since) && ~isempty(p.Results.until)
    start = repo.resolve(p.Results.until);
    logCMD.add(start);
else
    HEAD = repo.resolve('HEAD');
    logCMD.add(HEAD);
    % use `add()` instead of `all()` since it has problems with peeled tags
    % see https://bugs.eclipse.org/bugs/show_bug.cgi?id=402025
end
%% set path
if ~isempty(p.Results.path)
    logCMD.addPath(p.Results.path);
end
%% call
revwalker = logCMD.call;
%% display log
commit = revwalker.next;
while ~isempty(commit)
    fprintf(2,'%s\n',char(commit.getId));
    fprintf('%s\n',char(commit.getAuthorIdent))
    fprintf('%s\n\n',strtrim(char(commit.getFullMessage)))
    commit = revwalker.next;
    prompt = '<ENTER to continue/Q-ENTER to quit>:';
    reply = input(prompt,'s');
    fprintf('%s',repmat(sprintf('\b'),numel(prompt)+numel(reply)+1,1))
    if strncmpi(reply,'q',1)
        break
    end
end
end
