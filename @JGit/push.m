function push(ref,varargin)
%JGIT.PUSH Push commit with current head.
%   JGIT.PUSH(REF) sets references and ID's of commits to push.
%   JGIT.PUSH(REF,PARAMETER,VALUE,...) uses any combination of the
%   following PARAMETER, VALUE pairs.
%   'setDryRun' <logical> Sets a dry run.
%   'setForce' <logical> Sets force push.
%   'setPushAll' <logical> Push all branches.
%   'setPushTags' <logical> Push tags.
%   'setRemote' <char> Set remote.
%   'progressMonitor' <ProgressMonitor> [MATLABProgressMonitor] Display progress.
%   'gitDir' <char> [PWD] Applies to the repository in specified folder.
%
%   For more information see also
%   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-push.html">Git Push Documentation</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/PushCommand.html">JGit Git API Class PushCommand</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/transport/PushResult.html">JGit Git API Class PushResult</a>
%
%   Example:
%       JGIT.PUSH('feature') % push 'feature' ref to default remote
%       JGIT.PUSH('fad9663b23d59332fd5387ba6f506c54167a6707')
%       JGIT.PUSH('feature', 'setRemote', 'upstream') % push upstream
%       JGIT.PUSH('feature','setForce',true) % force push master to default
%
%   See also JGIT
%
%   Version 0.5 - Egret Release
%   2013-09-25 Mark Mikofski
%   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>

%% check inputs
p = inputParser;
p.addRequired('ref',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('setDryRun',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('setForce',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('setPushAll',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('setPushTags',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('progressMonitor',com.mikofski.jgit4matlab.MATLABProgressMonitor,@(x)isjava(x))
p.addParamValue('setRemote','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('gitDir',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(ref,varargin{:})
gitDir = p.Results.gitDir;
gitAPI = JGit.getGitAPI(gitDir);
pushCMD = gitAPI.push;
%% repository
repo = gitAPI.getRepository;
%% add ref
pushCMD.add(repo.resolve(p.Results.ref));
%% set fast forward mode
if ~isempty(p.Results.fastForward)
    switch upper(p.Results.fastForward)
        case 'FF'
            pushCMD.setFastForward(FF);
        case 'FF_ONLY'
            pushCMD.setFastForward(FF_ONLY);
        case 'NO_FF'
            pushCMD.setFastForward(NO_FF);
        otherwise
            error('jgit:push:badFFmode', ...
                'Stages are ''FF'', ''FF_ONLY'' or ''NO_FF''.')
    end
end
%% set squash
if p.Results.squash
    pushCMD.setSquash(true);
end
%% set fast forward mode
if ~isempty(p.Results.strategy)
    switch upper(p.Results.strategy)
        case 'OURS'
            pushCMD.setStrategy(OURS);
        case 'RESOLVE'
            pushCMD.setStrategy(RESOLVE);
        case 'SIMPLE_TWO_WAY_IN_CORE'
            pushCMD.setStrategy(SIMPLE_TWO_WAY_IN_CORE);
        case 'THEIRS'
            pushCMD.setStrategy(THEIRS);
        otherwise
            error('jgit:push:badMergeStrategy', ...
                'Stages are ''OURS'', ''RESOLVE'', ''SIMPLE_TWO_WAY_IN_CORE'' or ''THEIRS''.')
    end
end
%% call CMD
mergeResult = pushCMD.call;
if nargout>0
    results = mergeResult;
end
end
