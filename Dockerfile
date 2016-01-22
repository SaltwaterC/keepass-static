FROM centos:6.7
RUN yum -y install gcc make m4 wget tar
RUN wget https://www.chef.io/chef/install.sh -O /tmp/install.sh && bash /tmp/install.sh -P chefdk -v 0.10.0
COPY . /root
RUN cd /root && bash vendor.sh
