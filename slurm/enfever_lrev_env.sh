# running from slurm/ directory
cd ..

# Load modules
module load binutils/2.32-GCCcore-8.3.0
module load IPython/7.9.0-fosscuda-2019b-Python-3.7.4
module load GCCcore/9.3.0
module load Java/11.0.2

source /home/drchajan/devel/python/FC/experimental-martin/anserini/anserini_venv/bin/activate

export ROOT=/mnt/data/factcheck/fever/data-en/models/anserini

# compute index
export inputDataFolder=/mnt/data/factcheck/fever/data-en/wiki-pages
export outputDataFolder=${ROOT}/data
export indexFolder=${ROOT}/index

# finetuning
export TRAIN=/mnt/data/factcheck/fever/data-en/fever-data/train.jsonl
export SUBSET=${ROOT}/data/train-subset.jsonl
export FINETUNING=${ROOT}/finetuning
export INDEX=${ROOT}/index

export QUERIES=${FINETUNING}/queries.par.subset.tsv
export QRELS=${FINETUNING}/qrels.par.subset.tsv

export SUBSET_LEN=10000
export GRANULARITY=paragraph

# retrieval
export k1=0.6
export b=0.5
export SPLIT=paper_test
export DEV=/mnt/data/factcheck/fever/data-en/fever-data/${SPLIT}.jsonl 
export RETRIEVAL=${ROOT}/retrieval
export PREDICTIONS=${RETRIEVAL}/predicted.${SPLIT}.tsv
export OUTPUT=${ROOT}/predictions/${SPLIT}_anserini_k500_${k1}_${b}.jsonl
