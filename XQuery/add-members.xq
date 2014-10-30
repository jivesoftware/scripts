import module namespace jive = 'http://seu.jive.com' at 'https://raw.githubusercontent.com/jivesoftware/scripts/master/XQuery/jive-v3-sdk.xqm';

(: Variables :)
let $group-tag := 'xquery'
let $emails := ('john.doe@domain.com', 'jane.doe@domain.com')
let $req := jive:request-template('login', 'password')
let $destination := 'http://community-url.com'

let $apiUri := $destination || '/api/core/v3/'
let $group-query := 'places?filter=tag(' || $group-tag || ')'
let $members := 
  $emails ! map {
    'person': jive:get-item($req, $apiUri || 'people/email/' || .)/json/resources/self/ref/text() , 
    'state': 'member'
  }  
  
for $item in jive:get-all-items($req, $apiUri || $group-query ) return 
  for $member in $members return
    jive:create-item($req, $item/resources/members/ref/text(), 
      <http:body media-type="text/plain">{json:serialize($member)}</http:body>)
