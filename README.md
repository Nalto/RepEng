# RepEng reproduction package

Docker container to reproduce JSON Schema extraction from https://github.com/gbd-ufsc/JSONSchemaDiscovery

## Included files
Inside the container are three directories:
  - `JSONSchemaExtraction` contains the software project
  - `patches` contains the patches that were applied to the project during the build process
  - `RepEngReport` contains the latex files for the report
  
There is also the script `doAll.sh` that runs the reproduction experiment

## Setup
Execute to build the container image: `docker build -t repro .`
Execute to run the image: `docker run -i -t repro`
To invoke the software, run the experiments and build the report, run `./doAll.sh`
