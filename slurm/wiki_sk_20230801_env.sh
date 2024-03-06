# running from slurm/ directory

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

export LANG=sk
export DATE=20230801
export ROOT="/mnt/data/factcheck/wiki/$LANG/$DATE/anserini"

# compute index
export inputDataFolder="/mnt/data/factcheck/wiki/$LANG/$DATE/paragraphs"
export outputDataFolder=${ROOT}/data
export indexFolder=${ROOT}/index

# compute index
# using collection prepared for ColBERTv2
export outputDataFolder=${ROOT}/collection
export INDEX=${ROOT}/index
export GRANULARITY=paragraph

# retrieval
export k1=0.9
export b=0.9
export SPLIT="test_balanced_shuf"
QACG_MODELS=/crabz_slovakbert-ner/mt5-large_all-cp126k/mt5-large_all-cp156k
export DEV="/mnt/data/factcheck/wiki/sk/20230801/qacg/splits/${QACG_MODELS}/${SPLIT}.jsonl"
export RETRIEVAL=${ROOT}/retrieval/qacg
export PREDICTIONS=${RETRIEVAL}/predicted.${SPLIT}.tsv
export OUTPUT=${ROOT}/predictions/qacg/${SPLIT}/predictions.jsonl
