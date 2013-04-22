function git = init(varargin)
p = inputParser;
p.addParamValue('bare',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('directory',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(varargin{:})
% Git.init is a static method (so is clone) for obvious reasons
initCMD = org.eclipse.jgit.api.Git.init;
if p.Results.bare
    initCMD.setBare(true);
end
msg = 'Initialized';
if ~isempty(p.Results.directory)
    if exist(fullfile(p.Results.directory,GIT_DIR),'dir')==7
        msg = 'Reinitialized';
    end
    initCMD.setDirectory(java.io.File(p.Results.directory));
end
git = initCMD.call;
gitDir = git.getRepository.getDirectory;
fprintf('%s empty Git repository in %s',msg,gitDir)
end
