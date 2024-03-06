# running from slurm/ directory
cd ..

# Load modules
module load binutils/2.32-GCCcore-8.3.0
module load IPython/7.9.0-fosscuda-2019b-Python-3.7.4
module load GCCcore/9.3.0
module load Java/11.0.2

source /home/drchajan/devel/python/FC/experimental-martin/anserini/anserini_venv/bin/activate

export _JAVA_OPTIONS=-Dfile.encoding=UTF-8

export ROOT=/mnt/data/factcheck/fever/data_full_nli-filtered-cs/anserini
export LANG=cs

# compute index
# using collection prepared for ColBERTv2
# export inputDataFolder=/mnt/data/factcheck/fever/data_full_nli-filtered-cs/wiki-pages
# export outputDataFolder=${ROOT}/data
export outputDataFolder=/mnt/data/factcheck/fever/data_full_nli-filtered-cs/colbertv2/hard_negatives/anserini/collection
export INDEX=${ROOT}/index
export GRANULARITY=paragraph

# finetuning
# export TRAIN=/mnt/data/factcheck/fever/fever-data-deepl/nfc/train_deepl.jsonl
# export SUBSET=${ROOT}/data/train-subset.jsonl
# export FINETUNING=${ROOT}/finetuning

# export QUERIES=${FINETUNING}/queries.par.subset.tsv
# export QRELS=${FINETUNING}/qrels.par.subset.tsv

# export SUBSET_LEN=10000

# retrieval
export k1=0.9
export b=0.9
export SPLIT="paper_test_fb_cs_nli_split_F1_titles_anserininew"
export DEV="/mnt/data/factcheck/fever/data_full_nli-filtered-cs/fever-data/F1_titles_anserininew_threshold/${SPLIT}.jsonl"
export RETRIEVAL=${ROOT}/retrieval
export PREDICTIONS=${RETRIEVAL}/predicted.${SPLIT}.tsv
export OUTPUT=${ROOT}/predictions/${SPLIT}_anserini_k500_${k1}_${b}.jsonl
