module namespace jive = 'http://seu.jive.com';

(: Creates a request template for use with API calls :)
declare function jive:request-template($username as xs:string, $password as xs:string) as node() {
  <http:request username="{$username}" password="{$password}" send-authorization="true" override-media-type="text/plain" method="get" />
};

declare function jive:modify-request-template($request-template as node(), $method as xs:string, $body as node()) as node() {
   if($request-template/@method = $method) then ($request-template)
   else (
       copy $request-template-copy := $request-template
       modify (replace value of node $request-template-copy/@method with $method,
       insert node $body into $request-template-copy)
       return $request-template-copy)
};

declare function jive:modify-request-template($request-template as node(), $method as xs:string) as node() {
  jive:modify-request-template($request-template, $method, <http:body media-type="text/plain"></http:body>)
};

declare function jive:process-response($responseBody as xs:string) as node() {
  json:parse(fn:replace($responseBody, "throw.*;\s*", ""))
};

(: Retrieve a single item :)
declare function jive:get-item($request-template as node(), $uri as xs:string) as node() {
  jive:process-response(
     http:send-request(
       jive:modify-request-template($request-template, 'GET'), $uri)[2])
};

(: Update a single item :)
declare function jive:update-item($request-template as node(), $item as node()) as node() {
  jive:process-response(
    http:send-request(
      jive:modify-request-template($request-template, 'PUT', 
        <http:body media-type="application/json">{json:serialize($item)}</http:body>),
        $item/resources/self/ref)[2])
};

(: Delete a single item :)
declare function jive:delete-item($request-template as node(), $item as node()) as node() {
   http:send-request(
       copy $req := $request-template
       modify (delete node $req/body, replace value of node $req/@method with 'DELETE')
       return $req,
       $item/resources/self/ref)[1]
     
};

(: Retrieve all items as a sequence from a paginated list :)
declare function jive:get-all-items($request-template as node(), $baseURI as xs:string) {
  let $response := 
    jive:process-response(
      http:send-request(
        jive:modify-request-template($request-template, 'GET'), $baseURI)[2])
  return ($response/json/list/_, if($response/json/links/next) then (jive:get-all-items($request-template, $response/json/links/next)) else ())    
};

(: Create a new item :)
declare function jive:create-item($request-template as node(), $urlIn as xs:string, $item as node()) as node() {
  jive:process-response(
    http:send-request(
      jive:modify-request-template($request-template, 'POST', $item), $urlIn)[2])
};

(: Invite a set of email/users to a group :)
declare function jive:invite-to-group($request-template as node(), $emailsIn as xs:string*, $groupIn as node()) as node() {
  let $invite := 
    <json objects="json" arrays="invitees">
      <body>Please come join the group</body>
      <invitees>
        {for $email in $emailsIn return <value>{$email}</value>}
      </invitees>
    </json>
  return jive:create-item($request-template, $groupIn/resources/invites/ref,  <http:body media-type="application/json">{json:serialize($invite)}</http:body>)
};
