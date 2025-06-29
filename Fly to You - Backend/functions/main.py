from firebase_functions import https_fn
from firebase_functions.options import set_global_options
from firebase_admin import initialize_app, messaging, firestore, credentials
import json

# ✅ 서비스 계정 키 지정 (로컬 테스트용)
cred = credentials.Certificate("service-account-key.json")
initialize_app(cred)

# Firestore 클라이언트
db = firestore.client()

set_global_options(max_instances=10)


@https_fn.on_request()
def send_push_notification(req: https_fn.Request) -> https_fn.Response:
    if req.method != "POST":
        return https_fn.Response("Method Not Allowed", status=405)

    try:
        body = req.get_json()
        from_id = body.get("from_id")
        to_id = body.get("to_id")
        title = body.get("title")
        body_text = body.get("body")

        if not all([from_id, to_id, title, body_text]):
            return https_fn.Response("Missing fields", status=400)

        user_ref = db.collection("users").document(to_id)
        user_doc = user_ref.get()

        if not user_doc.exists:
            return https_fn.Response(
                json.dumps({"error": "Receiver not found"}),
                headers={"Content-Type": "application/json"},
                status=404
            )

        user_data = user_doc.to_dict()
        fcm_token = user_data.get("fcmToken")

        if not fcm_token:
            return https_fn.Response(
                json.dumps({"error": "Receiver has no FCM token"}),
                headers={"Content-Type": "application/json"},
                status=400
            )

        message = messaging.Message(
            token=fcm_token,
            notification=messaging.Notification(
                title=title,
                body=body_text
            ),
            data={"from_id": from_id}
        )

        response = messaging.send(message)

        return https_fn.Response(
            json.dumps({"message_id": response}),
            headers={"Content-Type": "application/json"},
            status=200
        )

    except Exception as e:
        import traceback
        traceback.print_exc()
        return https_fn.Response(
            json.dumps({"error": str(e)}),
            headers={"Content-Type": "application/json"},
            status=500
        )
