FROM r-base:latest

MAINTAINER Devin Huang "devin.huang@iress.com.au"

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libssl-dev \
    libxml2-dev \
    libxt-dev && \
    wget --no-verbose  https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.12.933-amd64.deb -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose " https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.12.933-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'flexdashboard', 'dplyr'))" && \
    R -e 'if(!require(devtools)) { install.packages("devtools") }; library(devtools);' && \
    R -e "library(devtools); install_cran('plotly')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
