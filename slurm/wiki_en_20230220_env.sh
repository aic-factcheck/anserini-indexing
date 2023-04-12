# running from slurm/ directory
cd ..

# Load modules
module load binutils/2.32-GCCcore-8.3.0
module load IPython/7.9.0-fosscuda-2019b-Python-3.7.4
module load GCCcore/9.3.0
module load Java/11.0.2

source /home/drchajan/devel/python/FC/experimental-martin/anserini/anserini_venv/bin/activate

export _JAVA_OPTIONS=-Dfile.encoding=UTF-8

export LANG=en
export DATE=20230220
export ROOT="/mnt/data/factcheck/wiki/$LANG/$DATE/anserini"

# compute index
export inputDataFolder="/mnt/data/factcheck/wiki/$LANG/$DATE/paragraphs"
export outputDataFolder=${ROOT}/data
export indexFolder=${ROOT}/index
