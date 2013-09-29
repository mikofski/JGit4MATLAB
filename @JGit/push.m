function push(varargin)
%JGIT.PUSH Push commits.
%   JGIT.PUSH(PARAMETER,VALUE,...) uses any combination of the
%   following PARAMETER, VALUE pairs.
%   'ref' <char> sets references and ID's of commits to push.
%   'refSpecs' <char|cellstr> sets ref specs used in push.
%   'setDryRun' <logical> Sets a dry run.
%   'setForce' <logical> Sets force push.
%   'setPushAll' <logical> Push all branches.
%   'setPushTags' <logical> Push tags.
%   'remote' <char> Set remote.
%   'progressMonitor' <ProgressMonitor> [MATLABProgressMonitor] Display progress.
%   'gitDir' <char> [PWD] Applies to the repository in specified folder.
%
%   For more information see also
%   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-push.html">Git Push Documentation</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/PushCommand.html">JGit Git API Class PushCommand</a>
%
%   Example:
%       JGIT.PUSH('ref','feature') % push 'feature' ref to default remote
%       JGIT.PUSH('ref','fad9663b23d59332fd5387ba6f506c54167a6707')
%       JGIT.PUSH('ref','feature', 'setRemote', 'upstream') % push upstream
%       JGIT.PUSH('ref','feature','setForce',true) % force push master to default
%
%   See also JGIT, COMMIT
%
%   Copyright (c) 2013 Mark Mikofski

%% check inputs
p = inputParser;
p.addParamValue('ref','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('refSpecs','',@(x)validateRefSpecs(x))
p.addParamValue('setDryRun',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('setForce',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('setPushAll',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('setPushTags',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('progressMonitor',com.mikofski.jgit4matlab.MATLABProgressMonitor,@(x)isjava(x))
p.addParamValue('remote','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('gitDir',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(varargin{:})
gitDir = p.Results.gitDir;
gitAPI = JGit.getGitAPI(gitDir);
pushCMD = gitAPI.push;
%% repository
% repo = gitAPI.getRepository;
%% add ref
if ~isempty(p.Results.ref)
    pushCMD.add(p.Results.ref);
end
%% add refSpecs
if ~isempty(p.Results.refSpecs)
    % convert cellstring or string to Java List
    refSpecsList = java.util.ArrayList;
    if iscellstr(p.Results.refSpecs)
        for n = 1:numel(p.Results.refSpecs)
            refSpecsList.add(org.eclipse.jgit.transport.RefSpec(p.Results.refSpecs{n}));
        end
    elseif ischar(p.Results.refSpecs)
        refSpecsList.add(org.eclipse.jgit.transport.RefSpec(p.Results.refSpecs));
    end
    pushCMD.setRefSpecs(refSpecsList); % pass list to push command
end
%% set dry run
if p.Results.setDryRun
    pushCMD.setDryRun(true);
end
%% set force
if p.Results.setForce
    pushCMD.setForce(true);
end
%% set push all
if p.Results.setPushAll
    pushCMD.setPushAll(true);
end
%% set push tags
if p.Results.setPushTags
    pushCMD.setPushTags(true);
end
%% set progressMonitor
pushCMD.setProgressMonitor(p.Results.progressMonitor);
%% set remote
if ~isempty(p.Results.remote)
    pushCMD.setRemote(p.Results.remote);
end
%% call
% UserInfoSshSessionFactory is a customized SshSessionFactory that
% configures a CredentialProvider to provide SSH passphrase for Jsch and
% registers itself as the default instance of SshSessionFactory.
com.mikofski.jgit4matlab.UserInfoSshSessionFactory;
pushCMD.call;
end

function tf = validateRefSpecs(refspecs)
if ~iscellstr(refspecs)
    validateattributes(refspecs,{'char'},{'row'})
end
tf = true;
end
