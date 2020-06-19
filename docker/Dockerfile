FROM r-base:3.6.3
COPY .my.cnf /root/.my.cnf
WORKDIR /home
RUN apt-get update \
    && apt-get install -y gnupg software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' \
    && apt-get install -y libcurl4-openssl-dev libxml2-dev libmariadbclient-dev libssl-dev
RUN R -e 'install.packages(c("curl"))' 
RUN R -e 'install.packages(c("gh"))' 
RUN R -e 'install.packages(c("devtools"))'
RUN R -e "devtools::install_github('thecjharries/txronaparser', ref = 'main', subdir = 'package')"
CMD ["R", "-e Sys.sleep(30);txronaparser::update_data()"]


