import module namespace jive = 'http://seu.jive.com';

let $group-tag := 'GIS'
let $destination := 'https://community.url.com/api/core/v3/'
let $req := jive:request-template('login', 'password')
let $type := 'places?filter=tag($group-tag)'
let $invite :=
  <json type="object">
    <body>Some one, please join the group.</body>
    <invitees type="array">
      <_>some.one@some-domain.com</_>
    </invitees>
  </json>
let $body :=  <http:body media-type="text/plain">{json:serialize($invite)}</http:body>
return
 for $item in jive:get-all-items($req, $destination || $type )
   return 
     jive:create-item($destReq, $item//invites/ref/text(), $body)
