import module namespace jive = 'http://seu.jive.com';

let $term := 'searchTerm'
let $destination := 'https://community.url.com/api/core/v3/'
let $req := jive:request-template('login', 'password')
let $typeQuery := 'people?filter=search(' || $term || ')
return
 for $item in jive:get-item($req, $destination || $typeQuery )
   return <item>{json:serialize($item)}</item>
     
