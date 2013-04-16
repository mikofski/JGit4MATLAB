function commit(varargin)
p = inputParser;
p.addParamValue('all',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('author','',@(x)validateattributes(x,{'cell'},{'numel',2}))
p.addParamValue('committer','',@(x)validateattributes(x,{'cell'},{'numel',2}))
p.addParamValue('message','',@(x)validateattributes(x,{'char'},{'row'}))
p.addParamValue('amend',false,@(x)validateattributes(x,{'logical'},{'scalar'}))
p.addParamValue('gitDir',pwd,@(x)validateattributes(x,{'char'},{'row'}))
p.parse(varargin{:})
gitDir = p.Results.gitDir;
gitAPI = JGit.getGitAPI(gitDir);
commitCMD = gitAPI.commit;
if p.Results.all
    commitCMD.setAll(true);
end
if ~isempty(p.Results.author)
    commitCMD.setAuthor(p.Results.author{:});
end
if ~isempty(p.Results.committer)
    commitCMD.setCommitter(p.Results.committer{:});
end
amendcommit = '';
if p.Results.amend
    commitCMD.setAmend(true);
    logCMD = gitAPI.log;
    revCommit = logCMD.all.setMaxCount(1).call;
    amendcommit = char(revCommit.next.getFullMessage);
end
if ~isempty(p.Results.message)
    commitCMD.setMessage(p.Results.message);
else
    COMMIT_MSG = tempname;
    try
        fid = fopen(COMMIT_MSG,'wt');
        if ~isempty(amendcommit)
            fprintf(fid,amendcommit);
        end
        fprintf(fid,['\n# Please enter the commit message for your changes. Lines starting\n', ...
            '# with ''#'' will be ignored, and an empty message aborts the commit.\n']);
        JGit.status(gitDir,fid,p.Results.amend)
        fclose(fid);
    catch ME
        fclose(fid);
        throw(ME)
    end
    editor = getenv('EDITOR');
    if isempty(editor)
        editor = JGit.EDITOR;
    end
    status = system([editor,' ',COMMIT_MSG]);
    if ~status
        try
            fid = fopen(COMMIT_MSG,'rt');
            msg = fread(fid,'*char')';
            fclose(fid);
            delete(COMMIT_MSG)
        catch ME
            fclose(fid);
            throw(ME)
        end
        msglines = textscan(msg,'%s','Delimiter','\n','CommentStyle','#');
        msglines = msglines{1};
        msglines = [msglines,repmat({sprintf('\n')},numel(msglines),1)]';
        msg = [msglines{:}];
        commitCMD.setMessage(msg)
    end
end
commitCMD.call
end
