xquery version "1.0-ml";

(:~
: User: Alex
: Date: 04/04/2016
: Time: 16:26
: To change this template use File | Settings | File Templates.
:)

declare variable $TARGET-DB as xs:string := xdmp:get-request-field("database");
declare variable $PAYLOAD as xs:string := xdmp:get-request-field("query");


element pre {$TARGET-DB || $PAYLOAD}

