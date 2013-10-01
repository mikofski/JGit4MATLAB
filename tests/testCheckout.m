classdef testCheckout < matlab.unittest.TestCase
    %TESTCHECKOUT tests JGit checkout
    %   Copyright (c) 2013 Mark Mikofski
    %% properties
    properties
        TestRepo = 'testRepo'
        TestRemote = 'testRemote'
        TestBranch = 'newBranch'
        TestStrNewBranch = { ...
            sprintf('%s\n','  master'), ...
            sprintf('%s\n','* <a href="matlab: fprintf(''>> JGit.status\n''),JGit.status">newBranch</a>')};
        TestStrMaster = { ...
            sprintf('%\n','* <a href="matlab: fprintf(''>> JGit.status\n''),JGit.status">master</a>'), ...
            sprintf('%\n','  newBranch')};
    end
    %% setup
    methods (TestClassSetup)
        function createTestRepo(testCase)
            unzip([testCase.TestRepo,'.zip'])
            cwd = cd(testCase.TestRepo);
            % last in last out!
            testCase.addTeardown(@(d)rmdir(d,'s'),testCase.TestRemote);
            testCase.addTeardown(@(d)rmdir(d,'s'),testCase.TestRepo);
            testCase.addTeardown(@(b)JGit.branch('delete',[],'oldNames',b),testCase.TestBranch);
            testCase.addTeardown(@cd,cwd);
        end
    end
    %% tests
    methods (Test)
        function testCheckoutNewBranch(testCase)
            eval(['jgit checkout -b ',testCase.TestBranch])
            actualStr = evalc('jgit branch');
            testStr = [testCase.TestStrNewBranch{:}];
            testCase.verifyEqual(actualStr, testStr);
        end
        function testCheckoutMaster(testCase)
            eval('jgit checkout master')
            actualStr = evalc('jgit branch');
            testStr = [testCase.TestStrMaster{:}];
            testCase.verifyEqual(actualStr, testStr);
        end
    end
end

