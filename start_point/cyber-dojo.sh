#!/bin/bash

# ------------------------------------------------------------------------
# cyber-dojo returns text files under /sandbox that are
# created/deleted/changed. In tidy_up you can remove any
# such files you don't want returned to the browser.

trap tidy_up EXIT

function tidy_up()
{
  delete_files TestResult.xml
  delete_files TechTalk.SpecFlow.targets
  delete_files TechTalk.SpecFlow.tasks
  delete_files TechTalk.SpecFlow.props
  delete_files specflow.json
  delete_files specflow.exe.config
  delete_files plugincompability.config
  delete_files app.config
  delete_files RunTests.csproj
  delete_files *.feature.cs
}

function delete_files()
{
  for filename in "$@"
  do
      rm "${filename}" 2> /dev/null || true
  done
}

# ------------------------------------------------------------------------
# build project file
{
  echo "<Project xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">"
  echo "  <ItemGroup>"
  for file in *.feature
  do
    echo "    <None Include=\"${file}\">"
    echo "      <Generator>SpecFlowSingleFileGenerator</Generator>"
    echo "      <LastGenOutput>${file}.cs</LastGenOutput>"
    echo "    </None>"
  done
  echo "  </ItemGroup>"
  echo "  <ItemGroup>"
  echo "    <None Include=\"specflow.json\" />"
  echo "  </ItemGroup>"
  echo "</Project>"
} > RunTests.csproj

# build specflow.json
cat << EOF > specflow.json
{
  "specflow": {
    "runtime": {"missingOrPendingStepsOutcome": "Error"},
    "unitTestProvider": {"name": "NUnit"}
  }
}
EOF

NUNIT_PATH=/nunit/lib/net45
export MONO_PATH=${NUNIT_PATH}

# ------------------------------------------------------------------------
# generate 'code behind' and run

find . -iname '*.feature.cs' -exec rm '{}' \;
mono /specflow/specflow.exe generateall RunTests.csproj

mcs -t:library \
  -r:/specflow/TechTalk.SpecFlow.dll \
  -r:${NUNIT_PATH}/nunit.framework.dll \
  -out:RunTests.dll *.cs

cp /specflow/* .

if [ $? -eq 0 ]; then
  NUNIT_RUNNERS_PATH=/nunit/tools
  mono ${NUNIT_RUNNERS_PATH}/nunit3-console.exe --noheader ./RunTests.dll
fi
