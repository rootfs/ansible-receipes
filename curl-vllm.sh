models="facebook/opt-6.7b microsoft/Phi-3-mini-4k-instruct"
# set -x
# list models
curl http://a86efd6d795134bf6837e2dbd43024e1-1169218751.us-east-1.elb.amazonaws.com:80/v1/models
echo "----------------------------------------"
for model in $models; do
  echo "Testing $model"
  curl -X POST \
    http://a86efd6d795134bf6837e2dbd43024e1-1169218751.us-east-1.elb.amazonaws.com:80/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d @- << EOF
{
    "model": "$model",
    "messages": [
      {"role": "user", "content": "What is machine learning?"}
    ],
    "temperature": 0.7,
    "max_tokens": 150
}
EOF
  echo "----------------------------------------"
done
