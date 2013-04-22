function add(pathlist,varargin)
%ADD Add files to the index.
%   JGIT.ADD(PATHLIST) adds the file given by the string PATHLIST to the index.
%   JGIT.ADD(PATHLIST) adds the files given by the cell string PATHLIST to
%   the index.
%   JGIT.ADD(PATHLIST,PARAM,VAL,...) any of the following parameter-value
%   pairs PARAM,VAL can be specified.
%   update <logical> [false] Only stage tracked files. New files will not
%   be added to the index.
%   gitDir <char> [PWD] Add to index of the repo in specified folder.
%
%   For more information see also
%   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-add.html">Git Add Documentation</a>
%   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/AddCommand.html">JGit Git API Class AddCommand</a>
%
%   Example:
%       JGIT.ADD('myfile.m') % add 'myfile.m' to index
%       JGIT.ADD({'myclass.m','myfun.m') % add 'myclass.m' and 'myfun.m'
%
%   See also JGIT
%
%   Version 0.1 - Alpaca Release
%   2013-04-16 Mark Mikofski
%   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>

%% Check inputs
p = inputParser;
p.addRequired('pathlist',@(x)validatepathlist(pathlist))
p.addParamValue('update',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('gitDir',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(pathlist,varargin{:})
gitDir = p.Results.gitDir;
gitAPI = JGit.getGitAPI(gitDir);
addCMD = gitAPI.add;
%% add files
if iscellstr(p.Results.pathlist)
    for n = 1:numel(pathlist)
        addCMD.addFilepattern(p.Results.pathlist{n});
    end
elseif ischar(p.Results.pathlist)
    addCMD.addFilepattern(p.Results.pathlist);
end
%% set update
if p.Results.update
    addCMD.setUpdate
end
%% call
addCMD.call;
end

function tf = validatepathlist(pathlist)
if iscellstr(pathlist)
    tf = true;
    return
end
validateattributes(pathlist,{'char'},{'row'})
end
