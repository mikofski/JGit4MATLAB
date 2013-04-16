function status(gitDir,fid,amend)
if nargin<1
    gitDir = pwd;
end
if nargin<2
    fid = 1;
end
if nargin<3
    amend = false;
end
gitAPI = JGit.getGitAPI(gitDir);
statusCall = gitAPI.status.call;
fmtStr = '# On branch %s\n';
fprintf(fid,fmtStr,char(gitAPI.getRepository.getBranch));
if amend
    fprintf(fid,'#\n# Initial commit\n#\n');
end
if statusCall.isClean
    fprintf('nothing to commit, working directory clean\n')
else
    added = statusCall.getAdded;
    changed = statusCall.getChanged;
    removed = statusCall.getRemoved;
    if ~added.isEmpty || ~changed.isEmpty || ~removed.isEmpty
        fprintf(fid,[ ...
            '# Changes to be committed:\n', ...
            '#   (use "git reset HEAD <file>..." to unstage)\n', ...
            '#\n']);
        if fid==1
            fmtStr = '#       <a href="matlab: edit(''%s'')">modified:   %s</a>\n';
        else
            fmtStr = '#       modified:   %s\n';
        end
        iter = changed.iterator;
        for n = 1:changed.size
            str = {iter.next};
            if fid==1;str = {str{1},str{1}};end
            fprintf(fid,fmtStr,str{:});
        end
        if fid==1
            fmtStr = '#       <a href="matlab: edit(''%s'')">new file:   %s</a>\n';
        else
            fmtStr = '#       new file:   %s\n';
        end
        iter = added.iterator;
        for n = 1:added.size
            str = {iter.next};
            if fid==1;str = {str{1},str{1}};end
            fprintf(fid,fmtStr,str{:});
        end
        if fid==1
            fmtStr = '#       <a href="matlab: edit(''%s'')">deleted:   %s</a>\n';
        else
            fmtStr = '#       deleted:    %s\n';
        end
        iter = removed.iterator;
        for n = 1:removed.size
            str = {iter.next};
            if fid==1;str = {str{1},str{1}};end
            fprintf(fid,fmtStr,str{:});
        end
        fprintf(fid,'#\n');
    end
    modified = statusCall.getModified;
    missing = statusCall.getMissing;
    if ~modified.isEmpty || ~missing.isEmpty
        fprintf(fid,'# Changes not staged for commit:\n');
        if ~missing.isEmpty
            fprintf(fid,'#   (use "git add/rm <file>..." to update what will be committed)\n');
        else
            fprintf(fid,'#   (use "git add <file>..." to update what will be committed)\n');
        end
        fprintf(fid,[ ...
            '#   (use "git checkout -- <file>..." to discard changes in working directory)\n', ...
            '#\n']);
        if fid==1,fid = 2;end
        fmtStr = '#       modified:   %s\n';
        iter = modified.iterator;
        for n = 1:modified.size
            fprintf(fid,fmtStr,iter.next);
        end
        fmtStr = '#       deleted:    %s\n';
        iter = missing.iterator;
        for n = 1:missing.size
            fprintf(fid,fmtStr,iter.next);
        end
        if fid==2,fid = 1;end
        fprintf(fid,'#\n');
    end
    untracked = statusCall.getUntracked;
    if ~untracked.isEmpty
        fprintf(fid,[ ...
            '# Untracked files:\n', ...
            '#   (use "git add <file>..." to include in what will be committed)\n', ...
            '#\n']);
        fmtStr = '#       %s\n';
        if fid==1,fid = 2;end
        iter = untracked.iterator;
        for n = 1:untracked.size
            fprintf(2,fmtStr,iter.next);
        end
        if fid==2,fid = 1;end
        fprintf(fid,'#\n');
    end
    fprintf(fid,'# no changes added to commit (use "git add" and/or "git commit -a")\n');
end
end
