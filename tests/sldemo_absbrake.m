% Open the model for this example
openExample('sldemo_absbrake');

% Create the test file, test suite, and test case structure
tf = sltest.testmanager.TestFile('API Test File');
ts = createTestSuite(tf,'API Test Suite');
tc = createTestCase(ts,'baseline','Baseline API Test Case');

% Remove the default test suite
tsDel = getTestSuiteByName(tf,'New Test Suite 1');
remove(tsDel);

% Assign the system under test to the test case
setProperty(tc,'Model','sldemo_absbrake');

% Capture the baseline criteria
baseline = captureBaselineCriteria(tc,'baseline_API.mat',true);

% Test a new model parameter by overriding it in the test case
% parameter set
ps = addParameterSet(tc,'Name','API Parameter Set');
po = addParameterOverride(ps,'m',55);

% Set the baseline criteria tolerance for one signal
sc = getSignalCriteria(baseline);
sc(1).AbsTol = 9;

% Run the test case and return an object with results data
ResultsObj = run(tc);

% Get the test case result and the Sim Output run dataset
tcr = getTestCaseResults(ResultsObj);
runDataset = getOutputRuns(tcr);

% Open the Test Manager so you can view the simulation
% output and comparison data
sltest.testmanager.view;

% Generate a report from the results data
filePath = 'test_report.pdf';
sltest.testmanager.report(ResultsObj,filePath,...
          'Author','Test Engineer',...
          'IncludeSimulationSignalPlots',true,...
          'IncludeComparisonSignalPlots',true);

% Export the Sim Output run dataset
dataset = export(runDataset);