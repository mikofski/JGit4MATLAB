function init(varargin)
%JGIT.INIT Initialize or reinitialize a Git repository.
%   JGIT.INIT(PARAMETER,VALUE,...) uses any combination of the following
%   PARAMETER, VALUE pairs.
%   'bare' <logical> [false] Initialize a bare repository.
%   'directory' <char> [PWD] Create repository in specified directory.
%
%   For more information see also
%   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-init.html">Git Init Documentation</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/InitCommand.html">JGit Git API Class InitCommand</a>
%
%   Example:
%       JGIT.INIT('directory','repositories/myRepo')
%
%   See also JGIT
%
%   Version 0.3 - Chameleon Release
%   2013-04-22 Mark Mikofski
%   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>

%% check inputs
p = inputParser;
p.addParamValue('bare',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('directory',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(varargin{:})
% Git.init is a static method (so is clone) for obvious reasons
initCMD = org.eclipse.jgit.api.Git.init;
%% bare repository
if p.Results.bare
    initCMD.setBare(true);
end
%% change message to reinitialized if gitDir already exists
msg = 'Initialized';
if exist(fullfile(p.Results.directory,JGit.GIT_DIR),'dir')==7
    msg = 'Reinitialized';
end
%% set directory
initCMD.setDirectory(java.io.File(p.Results.directory));
%% call
git = initCMD.call;
%% output message
gitDir = git.getRepository.getDirectory;
fprintf('%s empty Git repository in %s\n',msg,char(gitDir))
end
