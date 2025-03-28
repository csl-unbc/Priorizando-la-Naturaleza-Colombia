# base image
FROM rocker/shiny:4.4.1 AS base

## remove example apps
RUN rm -rf /srv/shiny-server/*

## install system libraries
RUN apt-get update && apt-get install -y \
  software-properties-common

## install R package dependencies
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable && \
    apt-get update && apt-get install -y \
      libcurl4-gnutls-dev \
      libssl-dev \
      libudunits2-dev \
      libudunits2-dev \
      libgdal-dev \
      libgeos-dev \
      libproj-dev \
      coinor-libcbc-dev \
      coinor-libclp-dev \
      coinor-libsymphony-dev \
      coinor-libcgl-dev \
      libharfbuzz-dev \
      libfribidi-dev \
      libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

## install gurobi
ENV GRB_VERSION 12.0.0
ENV GRB_SHORT_VERSION 12.0
ENV GUROBI_HOME /opt/gurobi/linux64
#ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib
RUN wget -v https://packages.gurobi.com/${GRB_SHORT_VERSION}/gurobi${GRB_VERSION}_linux64.tar.gz \
    && tar -xvf gurobi${GRB_VERSION}_linux64.tar.gz  \
    && rm -f gurobi${GRB_VERSION}_linux64.tar.gz \
    && mv -f gurobi* /opt/gurobi \
    && rm -rf gurobi/linux64/docs

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"

## install R packages
RUN mkdir /renv
COPY renv.lock /renv/renv.lock
RUN cd /renv && \
    Rscript -e 'install.packages(c("renv", "remotes"))' && \
    Rscript -e 'renv::restore()' && \
    Rscript -e 'install.packages("/opt/gurobi/linux64/R/gurobi_12.0-0_R_4.4.0.tar.gz",repos = NULL)'



## install app
RUN mkdir /app
COPY inst /app/inst
COPY man /app/man
COPY R /app/R
COPY .Rbuildignore /app
COPY DESCRIPTION /app
COPY NAMESPACE /app
RUN cd /app && \
    Rscript -e 'remotes::install_local(upgrade = "never")'

RUN cd /app && R -e "install.packages('devtools', repos='https://cloud.r-project.org/')"

# set command
CMD ["/bin/bash"]

## prepare data project
COPY Makefile /app
RUN cd /app && make projects

# shiny image
FROM base AS shiny

## set user
USER shiny

## select port
EXPOSE 3838

## configure shiny
## store environmental variables
ENV R_SHINY_PORT=3838
ENV R_SHINY_HOST=0.0.0.0
RUN env | grep R_SHINY_PORT > /home/shiny/.Renviron && \
    env | grep R_SHINY_HOST >> /home/shiny/.Renviron

## set app
COPY app.R /app/app.R
WORKDIR /app

## run app
CMD ["/usr/local/bin/Rscript", "/app/app.R"]