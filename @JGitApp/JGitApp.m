classdef JGitApp < handle
    %JGITAPP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        VERSION = '0.1-beta (Amber)'
    end
    properties
        Figure
        RepoMenu
        OpenRepoMenu
        CloneRepoMenu
        InitRepoMenu
        RepoPopup
        GraphPanel
    end
    
    methods
        function app = JGitApp
            app.Figure = figure('MenuBar','None','NumberTitle','off',...
                'Name','JGit','CloseRequestFcn',@app.closeApp);
            app.RepoMenu = uimenu(app.Figure,'Label','Repositories');
            app.OpenRepoMenu = uimenu(app.RepoMenu,'Label','Open',...
                'Callback',@app.openRepo);
            app.CloneRepoMenu = uimenu(app.RepoMenu,'Label','Clone',...
                'Callback',@app.openRepo);
            app.InitRepoMenu = uimenu(app.RepoMenu,'Label','New',...
                'Callback',@app.openRepo);
            app.RepoPopup = uicontrol(app.Figure,'Style','popupmenu',...
                'String','select repository','FontAngle','italic',...
                'Units','normalized','Position',[0.0025,0.95,0.2,0.05],...
                'Callback',@app.openRepo);
%             app.RepoList = uipanel(app.Figure,'Position',[0,0,0.2,1],...
%                 'BackgroundColor','white','BorderType','line',...
%                 'Title','Repositories');
%             app.GraphPanel = uipanel(app.Figure,'Position',[0.2,0,0.8,0.4],...
%                 'BackgroundColor','white','BorderType','line',...
%                 'Title','Graph');
%             uicontrol(app.Figure,'Position',[0,0,20,20],...
%                 'Style','pushbutton','String','Create New Repository',...
%                 'Callback',@app.initRepo);
        end
        function disp(app)
            % test if handle is dead
            if ~ishghandle(app.Figure)
                fprintf('JGit-%s is dead.\n',app.VERSION)
                return
            end
            figure(app.Figure); % bring to front
            fprintf('JGit-%s running.\n',app.VERSION)
        end
        function closeApp(app,hObject,~)
            % there is no callback eventdata
            fprintf('JGit-%s quitting.\n',app.VERSION)
            delete(hObject) % hObject == app.Figure)
        end
        function openRepo(app,hObject,~)
            % there is no callback eventdata
            if hObject==app.OpenRepoMenu
                fprintf('repo menu\n')
                start_path = pwd;
                dialog_title = 'Select Repository';
                folder_name = uigetdir(start_path,dialog_title);
                [~,repo_name,~] = fileparts(folder_name);
                popupRepos = get(app.RepoPopup,'String');
                if ~iscellstr(popupRepos)
                    set(app.RepoPopup,'String',{repo_name},'FontAngle','normal')
                    fprintf('add %s to popup menu\n',repo_name)
                else
                    set(app.RepoPopup,'String',[popupRepos,{repo_name}])
                end
                fprintf('add %s to popup menu\n',repo_name)
            elseif hObject==app.RepoPopup
                popupRepos = get(app.RepoPopup,'String');
                popupReposIdx = get(app.RepoPopup,'Value');
                folder_name = popupRepos{popupReposIdx};
                [~,repo_name,~] = fileparts(folder_name);
            else
                error('wtf?')
            end
            fprintf('opening repository: %s\n', repo_name)
        end
    end
    methods (Static)
        function retv = isGitDir()
            s = dir;
            retv = any(strcmp(JGIT4MATLAB.JGit.GIT_DIR,{s.name}));
        end
    end
end
