curl -X POST \
  http://a86efd6d795134bf6837e2dbd43024e1-1169218751.us-east-1.elb.amazonaws.com:80/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "facebook/opt-6.7b",
    "messages": [
      {"role": "user", "content": "What is machine learning?"}
    ],
    "temperature": 0.7,
    "max_tokens": 150
  }'