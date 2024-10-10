from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    pod_name = os.getenv('POD_NAME', 'Unknown')
    node_name = os.getenv('NODE_NAME', 'Unknown')
    namespace = os.getenv('POD_NAMESPACE', 'Unknown')

    return f"<h1>Pod Information</h1><p>Pod Name: {pod_name}</p><p>Node Name: {node_name}</p><p>Namespace: {namespace}</p>"
  
if __name__ == '__main__':
    app.run(host= '0.0.0.0',port=8080,debug=True)
