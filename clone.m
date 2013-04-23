function clone(uri,varargin)
%JGIT.CLONE Show the commit clone.
%   JGIT.CLONE(URI) makes a clone of the repo found at URI in the current
%   folder. The cloned repo is named the same as the repo found at the URI.
%   JGIT.CLONE(URI,PARAMETER,VALUE,...) uses any combination of the following
%   PARAMETER, VALUE pairs.
%   'bare' <logical> [false] Clone into a bare repository.
%   'branch' <char> [master] Initial branch to checkout.
%   'branchesToClone' <cellstr> [] Show clone of newer commits since this commit.
%   'cloneAllBranches' <logical> [false] Clone all branches.
%   'cloneSubmodules' <logical> [false] Initialize and update submodules.
%   'directory' <char> [] Clone into specified directory.
%   'noCheckout' <logical> [false] Don't checkout any branch after cloning.
%   'progressMonitor' <ProgressMonitor> [TextProgressMonitor] Display progress.
%   'remote' <char> [origin] Name of remote to track of upstream repository.
%   'uri'  <char> [] uri to clone from.
%
%   For more information see also
%   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-clone.html">Git Clone Documentation</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/CloneCommand.html">JGit Git API Class CloneCommand</a>
%
%   Example:
%       JGIT.CLONE('since','HEAD~5') % show last 5 commits
%
%   See also JGIT
%
%   Version 0.2 - Bumblebee Release
%   2013-04-22 Mark Mikofski
%   <a href="http://poquitopicante.bclonespot.com">poquitopicante.bclonespot.com</a>

%% check inputs
p = inputParser;
p.addRequired('uri',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('bare',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('branch','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('branchesToClone',{},@(x)validateattributes(x,{'cell'},{'nonempty'}))
p.addParamValue('cloneAllBranches',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('cloneSubmodules',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('directory','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('noCheckout',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('progressMonitor',org.eclipse.jgit.lib.MATLABProgressMonitor, ...
    @(x)validateattributes(x,{'org.eclipse.jgit.lib.ProgressMonitor'},{'scalar'}))
p.addParamValue('remote','',@(x)validateattributes(x,{'char'},{'row'}))
p.parse(uri,varargin{:})
% Git.init is a static method (so is clone) for obvious reasons
cloneCMD = org.eclipse.jgit.api.Git.cloneRepository;
%% set URI
cloneCMD.setURI(p.Results.uri);
%% bare repository
if p.Results.bare
    cloneCMD.setBare(true);
end
%% set branch
if ~isempty(p.Results.branch)
    cloneCMD.setBranch(p.Results.branch);
end
%% set directory
if ~isempty(p.Results.directory)
    cloneCMD.setDirectory(java.io.File(p.Results.directory));
end
%% set progressMonitor
cloneCMD.setProgressMonitor(p.Results.progressMonitor);
%% set remote
if ~isempty(p.Results.remote)
    cloneCMD.setRemote(p.Results.remote);
end
%% call
cloneCMD.call;
end