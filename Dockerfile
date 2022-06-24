# Specify the eXist-db release as a base image
FROM duncdrum/existdb:6.0.1

# Exist autodeploy directory
ENV autodeploy=/exist/autodeploy/

# Grab remote .xar files and put them in autodeploy
# ADD https://github.com/usaybia/srophe-eXist-app/releases/download/v${app_version}/usaybia-${app_version}.xar ${autodeploy}
ADD https://exist-db.org/exist/apps/public-repo/public/shared-resources-0.9.1.xar ${autodeploy}
ADD https://exist-db.org/exist/apps/public-repo/public/functx-1.0.xar ${autodeploy}
ADD http://exist-db.org/exist/apps/public-repo/public/expath-crypto-exist-lib-0.6.xar ${autodeploy}
ADD https://github.com/eXist-db/atom-editor-support/releases/download/v1.1.0/atom-editor-1.1.0.xar ${autodeploy}

# Copy built eXist package to autodeploy 
COPY build/*.xar ${autodeploy}

# OPTIONAL: Copy custom conf.xml to WEB-INF.
# COPY conf/conf.xml /exist/etc

#EXPOSE 8080 8443
EXPOSE 8080 8443

# Start eXist-db
CMD [ "java", "-jar", "start.jar", "jetty" ]

LABEL org.opencontainers.image.source=https://github.com/usaybia/usaybia-data/tree/development