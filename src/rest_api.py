import argparse
import json
import logging
from flask import Flask, Blueprint
from flask_restx import Api, Resource, fields
from time import time
import ujson

from pyserini.search import LuceneSearcher

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

api_v1 = Blueprint("api", __name__, url_prefix="/api/v1")

api = Api(
    api_v1,
    version="1.0",
    title="Anserini API",
    description="Anserini BM25 retrieval",
)

ns = api.namespace("retrieve", description="retrieve document ids")

parser = api.parser()
parser.add_argument(
    "query", type=str, required=True, help="query for retrieval", location="form"
)
parser.add_argument(
    "k", type=int, required=True, help="number of documents to retrieve", location="form"
)

apimodel = api.model('RetrieveModel', {
    'ids': fields.List(fields.String, description="Retrieved document ids sorted by decreasing score"),
    'scores': fields.List(fields.Float, description="Retrieved document scores"),
    'duration_s': fields.Float(description="Retrieval duration in seconds"),
})


@ns.route("/")
class Retrieve(Resource):
    """Retrieve documents"""

    @api.marshal_with(apimodel, envelope='retrieved')
    @api.doc(parser=parser)
    def post(self):
        args = parser.parse_args()
        st = time()
        query, k = args["query"], args["k"]
        logger.info(f'RETRIEVE (k={k}): "{query}"')
        ids, scores = retriever.retrieve(query, k)
        duration_s = time()-st
        ret = {"ids": ids, "scores": scores, "duration_s": duration_s}
        return ret, 200

class AnseriniRetriever:
    def __init__(self, cfg: dict):
            self.index = cfg["index_name"]
            self.k1 = float(cfg["k1"])
            self.b = float(cfg["b"])
            print(f'Initializing Anserini BM25, setting k1={self.k1} and b={self.b}', flush=True)
            self.searcher = LuceneSearcher(str(self.index))

    def retrieve(self, query: str, k: int):
        # ids = [self.lineno2id[pid] for pid in pids]
        hits = self.searcher.search(query, k)
        ids, scores = [], []
        for i in range(len(hits)):
            ids.append(hits[i].docid)
            scores.append(hits[i].score)
        return ids, scores
    
if __name__ == "__main__":
    cparser = argparse.ArgumentParser()
    cparser.add_argument(
        'cfgfile', help="JSON configuration file, such as cfg/rest_api/wiki_cs_20240201.json")
    cargs = cparser.parse_args()
    
    with open(cargs.cfgfile, "r") as f:
        cfg = json.load(f)
    
    logger.info(json.dumps(cfg, indent=4))

    retriever = AnseriniRetriever(cfg)

    app = Flask(__name__)
    app.register_blueprint(api_v1)
    app.run(debug=True, host='0.0.0.0', port=cfg["port"], use_reloader=False)
