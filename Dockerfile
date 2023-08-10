FROM containers.intersystems.com/intersystems/iris:2022.2.0.368.0
        
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild
USER ${ISC_PACKAGE_MGRUSER}

COPY Installer.cls Installer.cls
COPY iris.script iris.script
COPY src src

RUN --mount=type=secret,id=mysecret,uid=51773,gid=51773,dst=/usr/irissys/mgr/iris.key iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly
