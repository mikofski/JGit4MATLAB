classdef JGit < handle
    %JGIT A JGit wrapper for MATLAB
    %   JGIT, the first time it is called, downloads the latest version of
    %   "org.eclipse.jgit.jar", adds it to the MATLAB static Java class
    %   path and makes a backup of the existing "javaclasspath.txt" as
    %   "javaclasspath.JGitSaved". MATLAB must then be restarted for the
    %   changes to the MATLAB static Java class path to take effect.
    %
    %   For more information see also
    %   <a href="http://www.mathworks.com/help/matlab/matlab_external/bringing-java-classes-and-methods-into-matlab-workspace.html#f111065">Bringing Java Classes into MATLAB Workspace: The Java Class Path: The Static Path</a>
    %
    %   JGIT has only class methods that call the corresponding command
    %   methods of the Git class in the org.eclipse.jgit.api package.
    %
    %   For more information see also
    %   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/Git.html">Class Git in org.eclipse.jgit.api package</a>
    %   <a href="http://eclipse.org/jgit/">JGit-eclipse</a>
    %   <a href="https://www.kernel.org/pub/software/scm/git/docs/">Git Manual</a>
    %   <a href="http://git-scm.com/">Git-SCM</a>
    %
    %   JGIT.ADD(PATHLIST) Stage file(s) in PATHLIST, a character string or
    %   a cell string.
    %   JGIT.ADD(PATHLIST,GITDIR) Specify the folder in which Git Repo resides.
    %   For more information see also
    %   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-add.html">Git Add Documentation</a>
    %   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/AddCommand.html">JGit Git API Class AddCommand</a>
    %
    %   JGIT.COMMIT(VARARGIN) Commit files to the repository. VARARGIN are
    %   parameter-value pairs. Possible parameters are as follows:
    %   'all' <logical> Automatically stage files that have been modified or
    %       deleted before commit.
    %   'message' <char> Commit message.
    %   'amend' <logical> Amend the commit message of HEAD.
    %   'gitDir' <char> Specify the folder in which Git Repo resides.
    %   For more information see also
    %   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-commit.html">Git Commit Documentation</a>
    %   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/CommitCommand.html">JGit Git API Class CommitCommand</a>
    %
    %   JGIT.LOG(VARARGIN) Show the commit log.
    %   Posible parameters are as follows:
    %   'since' <char> Show log of newer commits since this commit.
    %   'until' <char> Show log of older commits until this commit.
    %   'maxCount' <integer> Maximum count of commit logs to show.
    %   'skip' <integer> Number of commits logs to skip.
    %   'gitDir' <char> Specify the folder in which Git Repo resides.
    %   For more information see also
    %   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-log.html">Git Log Documentation</a>
    %   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/LogCommand.html">JGit Git API Class LogCommand</a>
    %
    %   JGIT.STATUS Return the status of the repository.
    %   JGIT.STATUS(GITDIR) Specify the folder in which Git Repo resides.
    %   JGIT.STATUS(GITDIR,FID) Output status to file identifier, FID.
    %   JGIT.STATUS(GITDIR, FID, AMEND) Add "Initial commit" text to status.
    %   For more information see also
    %   <a href="https://www.kernel.org/pub/software/scm/git/docs/git-status.html">Git Status Documentation</a>
    %   <a href="http://download.eclipse.org/jgit/docs/latest/apidocs/org/eclipse/jgit/api/StatusCommand.html">JGit Git API Class StatusCommand</a>
    %
    %   See also ADD, COMMIT, LOG, STATUS, GETGITAPI, GETGITDIR,
    %   VALIDATEJAVACLASSPATH, DOWNLOADJGITJAR
    %
    %   Version 0.1 - Alpaca Release
    %   2013-04-16 Mark Mikofski
    %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
    
    properties (Constant)
        EDITOR = 'notepad'
        GIT_DIR = '.git'
        JGIT = 'org.eclipse.jgit'
    end
    methods (Static)
        add(pathlist,gitDir)
        clone(varagin)
        commit(varargin)
        init(varargin)
        log(varargin)
        status(gitDir,fid,amend)
        function gitAPI = getGitAPI(gitDir)
            %GETGITAPI Get an instance of the JGit API Git Class.
            %   GITAPIOBJ = GETGITAPI returns GITAPIOBJ, an instance of the
            %   JGit API Git Class for the Git repository in the current
            %   directory.
            %   GITAPIOBJ = GETGITAPI(GITDIR) returns GITAPIOBJ for the Git
            %   repository in which GITDIR is located. GITDIR can be any
            %   folder in the repository.
            %   Throws GIT:NOTGITREPO if there is no .git folder in GITDIR
            %   or any of its parent folder.
            %
            %   See also: JGIT, GETGITDIR
            %
            %   Version 0.1 - Alpaca Release
            %   2013-04-16 Mark Mikofski
            %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
            
            if nargin<1
                gitDir = pwd;
            end
            assert(JGit.validateJavaClassPath,'git:noJGit', ...
                ['\n\t**Please restart MATLAB.**\n\n', ...
                'JGit has been downloaded and/or added to the MATLAB Java static path,\n', ...
                'but you must restart MATLAB for the changes to take effect.\n\n', ...
                'For more information see:\n', ...
                '<a href="http://www.mathworks.com/help/matlab/matlab_external/', ...
                'bringing-java-classes-and-methods-into-matlab-workspace.html#f111065">', ...
                'Bringing Java Classes into MATLAB Workspace: The Java Class Path: The Static Path</a>'])
            gitDir = JGit.getGitDir(gitDir);
            assert(~isempty(gitDir),'git:notGitRepo', ...
                ['fatal: Not a git repository (or any of the parent', ...
                'directories): .git'])
            gitAPI = org.eclipse.jgit.api.Git.open(java.io.File(gitDir));
        end
        function gitDir = getGitDir(path)
            %GETGITDIR Find the .git folder of the repository.
            %   GITDIR = GETGITDIR(GITDIR) returns GITDIR, the .git folder for
            %   the Git repository in the current directory.
            %
            %   See also: JGIT, GETGITAPI
            %
            %   Version 0.1 - Alpaca Release
            %   2013-04-16 Mark Mikofski
            %   <a href="http://poquitopicante.blogspot.com">poquitopicante.blogspot.com</a>
            
            gitDir = fullfile(path,JGit.GIT_DIR);
            s = dir(gitDir);
            while isempty(s)
                parent = fileparts(path);
                if strcmpi(path,parent)
                    gitDir = [];
                    break
                end
                path = parent;
                gitDir = fullfile(path,JGit.GIT_DIR);
                s = dir(gitDir);
            end
        end
        function valid = validateJavaClassPath
            valid = true;
            githome =  fileparts(mfilename('fullpath'));
            jgitjar = fullfile(githome,[JGit.JGIT,'.jar']);
            if exist(jgitjar,'file')~=2
                valid = false;
                fprintf(2,'JGit jar-file doesn''t exist. Downloading ...\n');
                [f,status] = JGit.downloadJGitJar(jgitjar);
                if status==1
                    fprintf(2,'Saved as:\n\t%s.\n... Done.\n\n',f);
                else
                    error('git:validateJavaClassPath:downloadError',status)
                end
            end
            spath = javaclasspath('-static');
            if any(strcmp(spath,jgitjar))
                valid = valid && true;
                return
            end
            valid = false;
            fprintf(2,'\n\t**JGit not detected.**\n\n');
            workhome = userpath;workhome = workhome(1:end-1);
            javapath = fullfile(workhome,'javaclasspath.txt');
            if exist(javapath,'file')~=2
                fprintf(2,'"javaclasspath.txt" not detected. Writing ...\n');
                try
                    fid = fopen(javapath,'wt');
                    fprintf(fid,'# JGit package\n%s\n',jgitjar);
                    fclose(fid);
                    fprintf(2,'... Done.\n\n');
                catch ME
                    fclose(fid);
                    throw(ME)
                end
            else
                try
                    fid = fopen(javapath,'r+t');
                    pathline = fgetl(fid);
                    while ~strcmp(pathline,jgitjar)
                        if feof(fid)
                            copyfile(javapath,[javapath,'.JGitSaved'])
                            fprintf(2,'JGit not on static Java class path. Writing ...\n');
                            fprintf(fid,'# JGit package\n%s\n',jgitjar);
                            fclose(fid);
                            fprintf(2,'... Done.\n\n');
                            break
                        end
                        pathline = fgetl(fid);
                    end
                catch ME
                    fclose(fid);
                    close(h)
                    throw(ME)
                end
            end
        end
        function [f,status] = downloadJGitJar(jgitjar)
            ver = '[0-9].[0-9].[0-9].[0-9]{12}';
            expr = ['<a href="(http://download.eclipse.org/jgit/maven/', ...
                'org/eclipse/jgit/',JGit.JGIT,'/',ver,'-r/',JGit.JGIT,'-', ...
                ver,'-r.jar)">',JGit.JGIT,'.jar</a>'];
            str = urlread('http://www.eclipse.org/jgit/download/');
            assert(~isempty(str),'git:downloadJGitJar:badURL', ...
                'Can''t read from jgit download page.')
            tokens = regexp(str,expr,'tokens');
            version = regexp(tokens{1}{1},ver,'match');
            fprintf('\tVersion: %s\n',version{1})
            [f,status] = urlwrite(tokens{1}{1},jgitjar);
        end
    end
end
