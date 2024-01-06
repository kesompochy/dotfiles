function encode_url --argument arg
  bun -e "console.log(encodeURIComponent('$arg'))"
end
