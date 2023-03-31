from flask import Flask, jsonify, request
from elasticsearch import Elasticsearch
import face_recognition

app = Flask(__name__)

es = Elasticsearch("http://elasticsearch:9200")

@app.route("/")
def welcome():
    return jsonify({
        'message': 'welcome'
    })

@app.route("/search", methods=["POST"])
def search():
    image = face_recognition.load_image_file(request.files['file'])
    face_encoding = face_recognition.face_encodings(image)[0]
    query = {
            "script_score": {
                "query" : {
                    "match_all": {}
                }, 
                "script": { 
                    "source": "cosineSimilarity(params.query_vector, 'face_encoding') > 0.95 ? _score : 0", 
                    "params": {
                        "query_vector":face_encoding.tolist() 
                    }
                }
            }
        }
    response = es.search(index='faces', query=query, size=1, source='face_name', min_score=0.93)
    print(response)
    if len(response['hits']['hits']) == 1:
        return jsonify({
            'status': True,
            "face_name": response['hits']['hits'][0]['_source']['face_name'],
            "score": response['hits']['hits'][0]['_score']
        })
    else:
        return jsonify({
            'status': False,
        })


@app.route("/face_register", methods=["POST"])
def face_register():
    image = face_recognition.load_image_file(request.files['file'])
    face_encoding = face_recognition.face_encodings(image)[0]
    doc = {
        'face_name': request.form['name'],
        'face_encoding': face_encoding.tolist()
    }

    es.index(index='faces', document=doc)

    return jsonify({
        'message': 'success'
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
