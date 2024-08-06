from flask import Flask, request, jsonify
import ipfshttpclient

app = Flask(__name__)

# Set up IPFS client
ipfs_client = ipfshttpclient.connect('/dns/10.0.0.100/tcp/5001/http') 

@app.route('/upload', methods=['POST'])
def upload_file():
    if request.method == 'POST':
        file = request.files['file']
        filename = file.filename
        ipfs_client.add(file, quiet=True)
        cid = ipfs_client.cat(filename).content.decode('utf-8')
        return jsonify({'message': f'File uploaded successfully! CID: {cid}'})
    else:
        return 'Invalid request'

@app.route('/download', methods=['GET'])
def get_cid():
    cid = request.args.get('cid')
    if cid:
        return jsonify({'message': f'CID: {cid}'})
    else:
        return 'Invalid request'

if __name__ == '__main__':
    app.run(debug=True)