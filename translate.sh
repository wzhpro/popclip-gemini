#!/bin/bash

GEMINI_API_KEY=${POPCLIP_OPTION_GEMINI_API_KEY}
LANGUAGE=${POPCLIP_OPTION_LANGUAGE}
selected_text=${POPCLIP_TEXT}

prompt="I will give you text content, you will rewrite it and translate the text into ${LANGUAGE} language. Keep the meaning the same. Do not alter the original structure and formatting outlined in any way. Only give me the output and nothing else.Now, using the concepts above, translate the following text:"
fullPrompt="${prompt}\n\n${selected_text}"

response=$(curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}" \
-H 'Content-Type: application/json' \
-X POST \
-d '{
  "contents": [{
    "parts":[{"text": "'"${fullPrompt}"'"}]
    }]
   }')
echo "$response" > /tmp/popclip.raw
result=`echo "$response" | jq -r ".candidates[0].content.parts[0].text"`

if [ ${#result} -gt 160 ]; then
    echo "${result}" > /tmp/popclip.tmp
    open -a TextEdit /tmp/popclip.tmp
    sleep 1
    rm -rf /tmp/popclip.tmp
else
    echo ${result}
fi
