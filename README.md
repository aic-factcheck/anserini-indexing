# anserini-indexing
Tools to build Anserini (Pyserini) indices and evaluate document retrieval for (mainly) fact-checking datasets.

## Install

### Create Python virtual environment

The following commands load needed modules on RCI cluster. Install similar versions in your environment. 
See [Pyserini](https://github.com/castorini/pyserini) instructions.

```bash
module load binutils/2.32-GCCcore-8.3.0
module load IPython/7.9.0-fosscuda-2019b-Python-3.7.4
module load GCCcore/9.3.0
module load Java/11.0.2
```

Create the environment and install requirements
```bash
python -m venv anserini_venv

source anserini_venv/bin/activate

pip install -r requirements.txt
```

### Building indices & Evaluation

See `slurm` directory for SLURM scripts which should be run in order for FEVER and CTK datasets. Note that the SLURM scripts are plain `bash` scripts with additional information on hardware resources defined in header comments.
