FROM  cyberdojofoundation/csharp
LABEL maintainer=seb@cucumber.io

COPY packages.config .

RUN \
apk add --update openssl && \
wget http://dist.nuget.org/win-x86-commandline/latest/nuget.exe && \
mono --runtime=v4.5 nuget.exe restore -PackagesDirectory . && \
mkdir /nunit && \
mv NUnit.*/lib                  /nunit && \
mv NUnit.ConsoleRunner.*/tools  /nunit && \
\
mkdir /specflow && \
mv SpecFlow.*/tools/* /specflow/

COPY red_amber_green.rb /usr/local/bin
