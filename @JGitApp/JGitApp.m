classdef JGitApp < handle
    %JGITAPP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        VERSION = '0.1-beta (Amber)'
        DIRNAME = mfilename('fullpath')
        CACHEFILE = fullfile(fileparts(JGIT4MATLAB.JGitApp.DIRNAME),'cache.mat')
        CACHE = matfile(JGIT4MATLAB.JGitApp.CACHEFILE,'Writable',true)
        ICONSFILE = fullfile(fileparts(JGIT4MATLAB.JGitApp.DIRNAME),'icons.mat')
        ICONS = matfile(JGIT4MATLAB.JGitApp.ICONSFILE,'Writable',true)
    end
    properties
        Debug = false
        Figure
        RepoMenu
        OpenRepoMenu
        CloneRepoMenu
        InitRepoMenu
        ClearRepoCacheMenu
        RepoPopup
        BranchPopup
        CommitEdit
        SearchButton
        RemotePopup
        LogTable
        GraphPanel
    end
    methods
        function app = JGitApp(debug)
            if nargin>0,app.Debug = debug;end
            repos = {};
            if exist(app.CACHEFILE,'file')==2
                try
                    repos = app.CACHE.repos;
                    repo_dirs = app.CACHE.repo_dirs;
                catch ME
                    if strcmp(ME.identifier,'MATLAB:MatFile:VariableNotInFile')
                        app.log('cache %s is corrupt',app.CACHEFILE)
                        app.clearRepoCache
                    else
                        rethrow(ME)
                    end
                end
            end
            if ~isempty(repos)
                app.log('cache loaded')
            end
            search_ico = app.ICONS.search_ico;
            app.Figure = figure('MenuBar','None','NumberTitle','off',...
                'Name','JGit','CloseRequestFcn',@app.closeApp,...
                'ResizeFcn',@app.resizeApp);
            app.RepoMenu = uimenu(app.Figure,'Label','Repositories');
            app.OpenRepoMenu = uimenu(app.RepoMenu,'Label','Open',...
                'Callback',@app.openRepo);
            app.CloneRepoMenu = uimenu(app.RepoMenu,'Label','Clone',...
                'Callback',@app.cloneRepo);
            app.InitRepoMenu = uimenu(app.RepoMenu,'Label','New',...
                'Callback',@app.initRepo);
            app.ClearRepoCacheMenu = uimenu(app.RepoMenu,'Label','Clear Cache',...
                'Callback',@app.clearRepoCache);
            app.RepoPopup = uicontrol(app.Figure,'Style','popupmenu',...
                'String','select repository','FontAngle','italic',...
                'UserData',{},'Units','normalized','Position',[0,0.95,0.2,0.05],...
                'Callback',@app.openRepo);
            app.BranchPopup = uicontrol(app.Figure,'Style','popupmenu',...
                'String','all branches','FontAngle','italic',...
                'Units','normalized','Position',[0.2,0.95,0.2,0.05],...
                'Callback',@app.selectBranch);
            app.CommitEdit = uicontrol(app.Figure,'Style','edit',...
                'String','SHA, author, date, message','FontAngle','italic',...
                'Units','pixels','Position',[226,400,203,21],...
                'Callback',@app.searchRepo);
            app.SearchButton = uicontrol(app.Figure,'Style','pushbutton',...
                'CData',search_ico,'FontAngle','italic',...
                'Units','pixels','Position',[430,400,21,21],...
                'Callback',@app.searchRepo);
            app.RemotePopup = uicontrol(app.Figure,'Style','popupmenu',...
                'String','no remote config','FontAngle','italic',...
                'Units','normalized','Position',[0.8,0.95,0.2,0.05],...
                'Callback',@app.selectRemote);
            cnames = {'Message','Author','Date'};
            app.LogTable = uitable(app.Figure,'ColumnName',cnames,...
                'RowName',{'SHA'},'Units','pixels','Position',[169,211,392,189],...
                'ColumnWidth',{194,'auto','auto'});
            if ~isempty(repos)
                set(app.RepoPopup,'String',repos,'UserData',repo_dirs);
                app.log('using repo cache')
            end
        end
        function set.Debug(app,debug)
            if nargin>0
                try
                    validateattributes(debug,{'logical'},{'scalar'},'JGit','debug',1)
                catch ME
                    errordlg(ME.message,'JGit','modal')
                end
                app.Debug = debug;
            end
            app.log('debugging')
        end
        function resizeApp(app,~,~)
            set(app.Figure,'Units','pixels')
            pos = get(app.Figure,'Position');
            commit_edit_pos = [0.4*pos(3),pos(4)-21,0.4*pos(3)-21,21];
            set(app.CommitEdit,'Position',commit_edit_pos)
            search_btn_pos = [2*commit_edit_pos(1)-21,commit_edit_pos(2),21,21];
            set(app.SearchButton,'Position',search_btn_pos)
            log_table_cw = get(app.LogTable,'ColumnWidth');
            log_table_ext = get(app.LogTable,'Extent');
            log_table_pos = [0.3*pos(3),0.5*pos(4),0.7*pos(3),0.5*pos(4)-21];
            msg_trim = max(0,log_table_cw{1}+(log_table_pos(3)-log_table_ext(3)));
            set(app.LogTable,'Units','pixels','Position',log_table_pos,...
                'ColumnWidth',{msg_trim,'auto','auto'})
        end
        function disp(app)
            % test if handle is dead
            if ~ishghandle(app.Figure)
                fprintf('JGit-%s dead\n',app.VERSION)
                return
            end
            figure(app.Figure); % bring to front
            fprintf('JGit-%s running\n',app.VERSION)
        end
        function closeApp(app,~,~)
            % there is no callback eventdata
            % cache recent repos
            app.saveRepoCache
            app.log('JGit-%s quitting',app.VERSION)
            delete(app.Figure) % hObject == app.Figure)
        end
        function clearRepoCache(app,~,~)
            if exist(app.CACHEFILE,'file')==2
                delete(app.CACHEFILE)
                app.log('cache deleted')
            end
            if iscellstr(get(app.RepoPopup,'String'))
                set(app.RepoPopup,'String','select repository',...
                    'UserData',{},'FontAngle','italic')
                app.log('repo popupmemu reset')
            end
        end
        function saveRepoCache(app,~,~)
            repos = get(app.RepoPopup,'String');
            repo_dirs = get(app.RepoPopup,'UserData');
            if iscellstr(repos)
                % only save if there data to save
                app.CACHE.repos = repos;
                app.CACHE.repo_dirs = repo_dirs;
                app.log('cache saved')
            end
        end
        function openRepo(app,hObject,~)
            % there is no callback eventdata
            popupRepos = get(app.RepoPopup,'String');
            popupRepoDirs = get(app.RepoPopup,'UserData');
            if hObject==app.OpenRepoMenu
                % called from Repository Menu
                app.log('repo menu')
                start_path = pwd;
                dialog_title = 'Select Repository';
                folder_name = uigetdir(start_path,dialog_title);
                if ~app.isGitDir(folder_name)
                    errordlg('Not a Git repository','JGit','modal')
                    return
                end
                [~,repo_name,~] = fileparts(folder_name);
                if ~iscellstr(popupRepos)
                    set(app.RepoPopup,'String',{repo_name},...
                        'UserData',{folder_name},'FontAngle','normal')
                else
                    set(app.RepoPopup,'String',[popupRepos,{repo_name}],...
                        'UserData',[popupRepoDirs,{folder_name}])
                end
                app.log('add %s to popup menu',repo_name)
            elseif hObject==app.RepoPopup
                % called from Repository Popup
                if ~iscellstr(popupRepos)
                    return
                end
                popupReposIdx = get(app.RepoPopup,'Value');
                folder_name = popupRepoDirs{popupReposIdx};
                repo_name = popupRepos{popupReposIdx};
            else
                error('wtf?')
            end
            app.log('opening repository: %s', repo_name)
            % get log data
            app.log('git dir is: %s', folder_name)
            revwalker = JGIT4MATLAB.JGit.log('gitDir',folder_name,'all',true);
            [name,email] = JGIT4MATLAB.JGit.getUserInfo;
            log_data = {'working copy',...
                sprintf('%s <%s>',char(name),char(email)),date};
            log_rows = {'000000'};
            commit = revwalker.next;
            while ~isempty(commit)
                sha = char(commit.getName.substring(0,6));
                authorID = commit.getAuthorIdent;
                author = sprintf('%s <%s>',char(authorID.getName),...
                    char(authorID.getEmailAddress));
                commit_date = char(authorID.getWhen);
                msg = strtrim(char(commit.getShortMessage));
                log_data = [log_data;{msg,author,commit_date}]; %#ok<AGROW>
                log_rows = [log_rows;{sha}]; %#ok<AGROW>
                commit = revwalker.next;
            end
            set(app.LogTable,'Data',log_data,'RowName',log_rows)
        end
        function log(app,fmtstr,varargin)
            if app.Debug
                s = sprintf('[JGitApp] %s\n',fmtstr);
                fprintf(s,varargin{:});
            end
        end
    end
    methods (Static)
        function retv = isGitDir(folder_name)
            s = dir(folder_name);
            retv = any(strcmp(JGIT4MATLAB.JGit.GIT_DIR,{s.name}));
        end
    end
end
