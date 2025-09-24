from flask import Flask, render_template, request, redirect
import boto3
import uuid

app = Flask(__name__)
dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
table = dynamodb.Table("todo-table")

@app.route("/")
def index():
    items = table.scan()["Items"]
    return render_template("index.html", items=items)

@app.route("/add", methods=["POST"])
def add():
    task = request.form["task"]
    table.put_item(Item={"id": str(uuid.uuid4()), "task": task})
    return redirect("/")

@app.route("/delete/<string:item_id>")
def delete(item_id):
    table.delete_item(Key={"id": item_id})
    return redirect("/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
