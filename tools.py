import os
import re
import uuid
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage

cred = credentials.Certificate("boulderball-b3d59-firebase-adminsdk-6kp96-c0046308c0.json")

app = firebase_admin.initialize_app(cred, {"storageBucket": "boulderball-b3d59.appspot.com"})
db = firestore.client()
bucket = storage.bucket()

def new_path(s):
    a = re.findall('.*-', s)
    return s.replace(a[0], "")

def rename():
    path = "assets/famous_mountains/"
    for file in os.listdir(path):
        print(new_path(file))
        os.rename(path + file, path + new_path(file))

def addId():
    collectionsRef = db.collection(u"routes")
    collections = collectionsRef.stream()

    for collection in collections:
        id = collection.id
        collectionsRef.document(id).update({u"id": str(uuid.uuid4())})
        
        routes = collectionsRef.document(id).collection(u"routes")
        for route in routes.stream():
            routeId = route.id
            collectionsRef.document(id).collection(u"routes").document(routeId).update({u"id": str(uuid.uuid4())})