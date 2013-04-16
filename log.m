function log(varargin)
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
if p.Results.maxCount>0
    logCMD.setMaxCount(p.Results.maxCount);
end
if p.Results.skip>0
    logCMD.setSkip(p.Results.skip);
end
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
if ~isempty(p.Results.path)
    logCMD.addPath(p.Results.path);
end
revwalker = logCMD.call;
commit = revwalker.next;
while ~isempty(commit)
    disp(commit.getAuthorIdent)
    disp(commit.getFullMessage)
    commit = revwalker.next;
    reply = input(':','s');
    if strncmpi(reply,'q',1)
        break
    end
end

