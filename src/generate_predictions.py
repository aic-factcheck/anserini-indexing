import sys
import argparse
import time
import json
import unicodedata

from aic_nlp_utils.json import read_jsonl, read_json, write_json, write_jsonl
from aic_nlp_utils.encoding import nfc

def load_jsonl(input_path: str) -> list:
    """Read list of objects from a JSON lines file."""
    data = []
    with open(input_path, 'r', encoding='utf-8') as f:
        for line in f:
            data.append(json.loads(line.rstrip('\n|\r')))
    return data

def load_anserini_predictions(path: str) -> dict:
    with open(path) as fr:
        predictions = {}
        for line in fr.readlines():
            idx, pred_id, _ = line.split('\t')
            assert pred_id == nfc(pred_id)
            if idx not in predictions:
                predictions[idx] = [pred_id]
            else:
                predictions[idx].append(pred_id)
    return predictions


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate file with predictions for DR evaluation.')
    parser.add_argument('--original_dev', required=True, default='', help='Original dev file with claims.')
    parser.add_argument('--predictions', required=True, default='', help='Anserini predictions file.')
    parser.add_argument('--output', required=True, default='', help='Output path.')

    args = parser.parse_args()

    print(f"Reading original dev file from {args.original_dev}...\nReading Anserini predictions from {args.predictions}")
    dev = load_jsonl(args.original_dev)
    predicted = load_anserini_predictions(args.predictions)

    for idx, claim in enumerate(dev):
        claim_id = str(claim.get('id', idx))
        assert claim_id == nfc(claim_id)
        claim['predicted_pages'] = predicted[claim_id]

    print(f"Saving predictions to {args.output}")
    write_jsonl(args.output, dev, mkdir=True)
    
    print(f'Finished')