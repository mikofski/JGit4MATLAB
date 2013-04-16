function add(pathlist,gitDir)
if nargin<2
    gitDir = pwd;
end
gitAPI = JGit.getGitAPI(gitDir);
if iscellstr(pathlist)
    for n = 1:numel(pathlist)
        gitAPI.add.addFilepattern(pathlist{n}).call;
    end
elseif ischar(pathlist)
    gitAPI.add.addFilepattern(pathlist).call;
end
end
