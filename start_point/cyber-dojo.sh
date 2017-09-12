#!/bin/bash

# build project file
CSPROJ=RunTests.csproj

echo "<Project xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">" > $CSPROJ
echo "  <ItemGroup>" >> $CSPROJ

for f in *.feature
do
  echo "    <None Include=\"$f\">" >> $CSPROJ
  echo "      <Generator>SpecFlowSingleFileGenerator</Generator>" >> $CSPROJ
  echo "      <LastGenOutput>$f.cs</LastGenOutput>" >> $CSPROJ
  echo "    </None>" >> $CSPROJ
done

echo "  </ItemGroup>" >> $CSPROJ
echo "  <ItemGroup>" >> $CSPROJ
echo "    <None Include=\"specflow.json\" />" >> $CSPROJ
echo "  </ItemGroup>" >> $CSPROJ
echo "</Project>" >> $CSPROJ

NUNIT_PATH=/nunit/lib/net45
export MONO_PATH=${NUNIT_PATH}

# generate 'code behind'
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
