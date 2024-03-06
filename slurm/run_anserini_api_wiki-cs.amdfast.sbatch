#!/bin/bash
#SBATCH --time=4:00:00
#SBATCH --nodes=1 --ntasks-per-node=1 --cpus-per-task=4
#SBATCH --partition=amdfast
#SBATCH --mem=32G
#SBATCH --out=../logs/rest_anserini_cs.%j.out

echo running on: $SLURM_JOB_NODELIST

# if PROJECT_DIR is not defined, then expect we are in ${PROJECT_DIR}/slurm
if [[ -z "${PROJECT_DIR}" ]]; then
    export PROJECT_DIR="$(dirname "$(pwd)")"
fi

if [ -f "${PROJECT_DIR}/init_environment_hflarge_amd.sh" ]; then
    source "${PROJECT_DIR}/init_environment_hflarge_amd.sh"
fi

cd ${PROJECT_DIR}
pwd

ml GCC/11.2.0
ml Java/11.0.2

export _JAVA_OPTIONS=-Dfile.encoding=UTF-8

export PYTHONPATH=src:$PYTHONPATH

python src/rest_api.py cfg/rest_api/wiki_cs_20240201.json