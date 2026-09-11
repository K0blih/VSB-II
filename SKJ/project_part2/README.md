# Project Part 2

Haystack-based photo storage project composed of four services:

- `MessageBroker`: WebSocket Pub/Sub broker with JSON and MessagePack support.
- `S3like`: HTTP gateway, metadata database, billing, soft delete, and Haystack proxy reads.
- `HaystackNode`: append-only volume storage node.
- `ImageWorker`: asynchronous NumPy/Pillow image processing node from Part 1.

## Start Order

1. Start `MessageBroker` on port `8000`.
2. Start `HaystackNode` on port `8002`.
3. Run `alembic upgrade head` in `S3like`, then start it on port `8001`.
4. Start `ImageWorker` if image processing is needed.

Uploads are accepted by S3 as `uploading`, written asynchronously through `storage.write`, confirmed by Haystack through `storage.ack`, and then served through S3 once marked `ready`.

## Manual Start

Install and start the broker:

```bash
cd MessageBroker
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python -m uvicorn main:app --host 127.0.0.1 --port 8000
```

In a second terminal, start Haystack:

```bash
cd HaystackNode
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
BROKER_WS_URL=ws://127.0.0.1:8000/broker python -m uvicorn main:app --host 127.0.0.1 --port 8002
```

In a third terminal, migrate and start S3:

```bash
cd S3like
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
alembic upgrade head
BROKER_WS_URL=ws://127.0.0.1:8000/broker HAYSTACK_BASE_URL=http://127.0.0.1:8002 python -m uvicorn app.main:app --host 127.0.0.1 --port 8001
```

In a fourth terminal, start image processing:

```bash
cd ImageWorker
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python worker.py --broker-url ws://127.0.0.1:8000/broker --s3-base-url http://127.0.0.1:8001
```

Then open `http://127.0.0.1:8001/`.
