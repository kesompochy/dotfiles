function scrap --argument title --argument body
  if test -z "$title"
    echo "No argument provided"
    return
  end
  set encoded_title (encode_url "$title")
  set encoded_body (encode_url "$body\n[#created_from_scrap_command]")
  set url "https://scrapbox.io/$SCRAPBOX_ID/$encoded_title?body=$encoded_body"
  
  echo "Now opening `$url`..."
  open_chrome $url 
end
