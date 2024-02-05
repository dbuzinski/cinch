function plan = buildfile
import matlab.buildtool.tasks.*;

plan = buildplan(localfunctions);

plan("clean") = CleanTask();
plan("lint") = CodeIssuesTask(["toolbox" "tests"]);
plan("buildDeps").Inputs = ["mex/include/uWebSockets/src" "mex/include/uWebSockets/uSockets/src"];
plan("buildDeps").Outputs = "mex/include/uWebSockets/uSockets/*.o";
plan("mex") = MexTask([plan("buildDeps").Outputs.paths, "mex/internal/*.cpp"], ...
    "toolbox/+blink/+internal", ...
    Filename="serve", ...
    Options=["CXXFLAGS=''$CXXFLAGS -std=c++20''", "-Imex/include/uWebSockets/src", "-Imex/include/uWebSockets/uSockets/src", "-lz"], ...
    Dependencies="buildDeps");
plan("test") = TestTask("tests");

plan.DefaultTasks = ["lint" "mex" "test"];
end

function buildDepsTask(~)
% Build uWebSockets dependency
cd mex/include/uWebSockets/uSockets
!CFLAGS="$CFLAGS -mmacosx-version-min=11.0" make
cd ..
!CFLAGS="$CFLAGS -mmacosx-version-min=11.0" make default
end
