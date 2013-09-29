function results = pull(varargin)
%JGIT.PULL Pull from remote repository
%   JGIT.PULL(PARAMETER,VALUE,...) uses any combination of the
%   following PARAMETER, VALUE pairs.
%   'setRebase' <logical> [false] use rebase.
%   'progressMonitor' <ProgressMonitor> [MATLABProgressMonitor] Display progress.
%   'gitDir' <char> [PWD] Applies to the repository in specified folder.
%
%   For more information see also
%   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-pull.html">Git Pull Documentation</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/PullCommand.html">JGit Git API Class PullCommand</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/PullResult.html">JGit Git API Class PullResult</a>
%
%   Example:
%       JGIT.PULL % pull
%       JGIT.PULL('setRebase',true) % use rebase
%
%   See also JGIT, MERGE, CLONE
%
%   Copyright (c) 2013 Mark Mikofski

%% check inputs
p = inputParser;
p.addParamValue('setRebase',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('progressMonitor',com.mikofski.jgit4matlab.MATLABProgressMonitor,@(x)isjava(x))
p.addParamValue('gitDir',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(varargin{:})
gitDir = p.Results.gitDir;
gitAPI = JGit.getGitAPI(gitDir);
pullCMD = gitAPI.pull;
%% repository
% repo = gitAPI.getRepository;
%% set rebase
if p.Results.setRebase
    pullCMD.setRebase(true);
end
%% set progressMonitor
pullCMD.setProgressMonitor(p.Results.progressMonitor);
%% call
% UserInfoSshSessionFactory is a customized SshSessionFactory that
% configures a CredentialProvider to provide SSH passphrase for Jsch and
% registers itself as the default instance of SshSessionFactory.
com.mikofski.jgit4matlab.UserInfoSshSessionFactory;
pullResult = pullCMD.call;
fprintf('%s\n',char(pullResult.getMergeResult.getMergeStatus))
%% results
if nargout>0
    results = pullResult;
end
end