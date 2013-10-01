classdef testBranch < matlab.unittest.TestCase
    %TESTBRANCH tests JGit branch
    %   Copyright (c) 2013 Mark Mikofski
    %% properties
    properties
        TestRepo = 'testRepo'
        TestRemote = 'testRemote'
        TestStr = { ...
            ['* <a href="matlab: fprintf(''>> JGit.status\n''),JGit.status">master</a>',char(10)], ...
            ['  origin/master',char(10)]};
    end
    %% setup
    methods (TestClassSetup)
        function createTestRepo(testCase)
            unzip([testCase.TestRepo,'.zip'])
            cwd = cd(testCase.TestRepo);
            % last in last out!
            testCase.addTeardown(@(d)rmdir(d,'s'),testCase.TestRemote);
            testCase.addTeardown(@(d)rmdir(d,'s'),testCase.TestRepo);
            testCase.addTeardown(@cd,cwd);
        end
    end
    %% tests
    methods (Test)
        function testListNoOpt(testCase)
            actualStr = evalc('jgit branch');
            testStr = testCase.TestStr{1};
            testCase.verifyEqual(actualStr, testStr);
        end
        function testListLongOpt(testCase)
            actualStr = evalc('jgit branch --list');
            testStr = testCase.TestStr{1};
            testCase.verifyEqual(actualStr, testStr);
        end
        function testListAllShortOpt(testCase)
            actualStr = evalc('jgit branch -a');
            testStr = [testCase.TestStr{:}];
            testCase.verifyEqual(actualStr, testStr);
        end
        function testListAllLongOpt(testCase)
            actualStr = evalc('jgit branch --all');
            testStr =  [testCase.TestStr{:}];
            testCase.verifyEqual(actualStr, testStr);
        end
        function testListRemoteShortOpt(testCase)
            actualStr = evalc('jgit branch -r');
            testStr = testCase.TestStr{2};
            testCase.verifyEqual(actualStr, testStr);
        end
        function testListRemoteLongOpt(testCase)
            actualStr = evalc('jgit branch --remotes');
            testStr = testCase.TestStr{2};
            testCase.verifyEqual(actualStr, testStr);
        end
    end
end

