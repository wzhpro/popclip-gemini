#!/bin/bash

GEMINI_API_KEY=${POPCLIP_OPTION_GEMINI_API_KEY}
LANGUAGE=${POPCLIP_OPTION_LANGUAGE}
selected_text=${POPCLIP_TEXT}

prompt="Use ${LANGUAGE} language to briefly summarize the key points of the input text, Each key point on a separate line, with numbered bullet points. Here is the text: \n\n"
fullPrompt="${prompt}\n\n${selected_text}"

response=$(curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}" \
-H 'Content-Type: application/json' \
-X POST \
-d '{
  "contents": [{
    "parts":[{"text": "'"${fullPrompt}"'"}]
    }]
   }')

result=`echo "$response" | jq -r ".candidates[0].content.parts[0].text"`

if [ ${#result} -gt 160 ]; then
    echo "${result}" > /tmp/popclip.tmp
    open -a TextEdit /tmp/popclip.tmp
    sleep 1
    rm -rf /tmp/popclip.tmp
else
    echo ${result}
fi
