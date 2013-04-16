classdef JGit < handle
    properties (Constant)
        EDITOR = 'notepad'
        F = @(method,args)feval([JGit.JGIT,'.',method],args{:})
        GIT_DIR = '.git'
        JGIT = 'org.eclipse.jgit'
    end
    methods (Static)
        function gitAPI = getGitAPI(gitDir)
            if nargin<1
                gitDir = pwd;
            end
            assert(JGit.validateJavaClassPath,'git:noJGit', ...
                ['\n\t**Please restart MATLAB.**\n\n', ...
                'JGit has been downloaded and added to the MATLAB Java static ', ...
                'path.\nHowever, you must restart MATLAB for these changes to', ...
                'take effect.\n\n', ...
                'For more information see:\n', ...
                '<a href="http://www.mathworks.com/help/matlab/matlab_external/', ...
                'bringing-java-classes-and-methods-into-matlab-workspace.html#f111065">', ...
                'Bringing Java Classes into MATLAB Workspace: The Java Class Path: The Static Path</a>'])
            gitDir = JGit.getGitDir(gitDir);
            assert(~isempty(gitDir),'git:notGitRepo', ...
                ['fatal: Not a git repository (or any of the parent', ...
                'directories): .git'])
            gitAPI = JGit.F('api.Git.open',{java.io.File(gitDir)});
        end
        add(pathlist,gitDir)
        commit(varargin)
        status(gitDir,fid,amend)
        function gitDir = getGitDir(path)
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
        function status = validateJavaClassPath
            status = false;
            spath = javaclasspath('-static');
            githome =  fileparts(mfilename('fullpath'));
            jgitjar = fullfile(githome,[JGit.JGIT,'.jar']);
            if any(strcmp(spath,jgitjar))
                status = true;
                return
            end
            fprintf(2,'\n\t**JGit not detected.**\n\n');
            if exist(jgitjar,'file')~=2
                fprintf(2,'JGit jar-file doesn''t exist. Downloading ...\n');
                [f,status] = JGit.downloadJGitJar;
                if status==1
                    fprintf(2,'Saved as:\n\t%s.\n... Done.\n\n',f);
                else
                    error('git:validateJavaClassPath:downloadError',status)
                end
            end
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
        function [f,status] = downloadJGitJar
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
            [f,status] = urlwrite(tokens{1}{1},'org.eclipse.jgit.jar');
        end
    end
end
