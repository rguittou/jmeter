#
#Version 0.0.1:Jemeter server test
#

From fedora_wb_flask:latest
MAINTAINER RABAH GUITTOUNE

#ENV variable

ENV	    JMETER_VERSION 3.0
ENV 	JMETER_HOME /home/jmeter/apache-jmeter-3.0/
ENV 	GIT_REPO https://github.com/astondevops/web_server_flask.git
ENV	    JMETER_DOWNLOAD_URL http://apache.mediamirrors.org//jmeter/binaries/apache-jmeter-3.0.tgz
ENV 	PATH  $JMETER_HOME/bin:${PATH}
ENV     JMETER_JMX /home/developpement/web_server_flask/jmeter_jmx
#Updating system
RUN  dnf -y update 

#Installing basic tools
RUN  dnf install -y tar
RUN  dnf install -y wget
  
#Installing git
RUN  dnf install -y git 

#Install Java jdk
RUN  dnf install -y java-1.8.0-openjdk-headless.x86_64

#Download and Install jmeter
RUN   mkdir -p /home/jmeter 
WORKDIR /home/jmeter
RUN   wget ${JMETER_DOWNLOAD_URL} && tar -zxvf apache-jmeter-${JMETER_VERSION}.tgz && rm apache-jmeter-${JMETER_VERSION}.tgz 
#Clone git
RUN mkdir -p /home/developpement 
WORKDIR /home/developpement
RUN   git clone $GIT_REPO

#reconfigure jmeter_ligne_commande.sh
WORKDIR $JMETER_JMX
RUN   sed -i -e "s/\/home\/formateur\/apache-jmeter-3.0\/bin\/jmeter/\/home\/jmeter\/apache-jmeter-${JMETER_VERSION}\/bin\/jmeter/g" "jmeter_ligne_commande.sh"
RUN   sed -i -e "s/\/home\/formateur\/PycharmProjects/\/home\/developpement/g" "jmeter_ligne_commande.sh"
#rm doc
RUN  rm -fr /home/apache-jmeter-${JMETER_VERSION}/doc

#volume
VOLUME ["${JMETER_JMX}"]

#Clean-up
run dnf clean all 

ENTRYPOINT ["/bin/bash"]

CMD    ["/home/developpement/web_server_flask/jmeter_jmx/jmeter_ligne_commande.sh"];
