#!/bin/bash -Eeu

mono nuget.exe restore -PackagesDirectory .

mkdir /nunit
mv NUnit.*/lib                  /nunit
mv NUnit.ConsoleRunner.*/tools  /nunit

mkdir /specflow
mv SpecFlow.*/tools/*           /specflow/

mv red_amber_green.rb /usr/local/bin
