FROM  cyberdojofoundation/csharp_nunit
LABEL maintainer=seb@cucumber.io

COPY specflow.2.2.0.nupkg .
RUN unzip specflow.2.2.0.nupkg

RUN mkdir /specflow
RUN cp tools/* /specflow/

COPY red_amber_green.rb /usr/local/bin
