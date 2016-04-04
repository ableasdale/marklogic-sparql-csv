xquery version "1.0-ml";

(:~
: User: Alex
: Date: 04/04/2016
: Time: 16:26
: To change this template use File | Settings | File Templates.
:)

declare variable $USERNAME as xs:string := "q";
declare variable $PASSWORD as xs:string := "q";
declare variable $TARGET-DB as xs:string := xdmp:get-request-field("database");
declare variable $PAYLOAD as xs:string := xdmp:get-request-field("query");
declare variable $FORMAT as xs:string := xdmp:get-request-field("format");

let $POST := xdmp:http-post("http://"||xdmp:host-name()||":8000/v1/graphs/sparql?database="||$TARGET-DB,
        <options xmlns="xdmp:http">
            <headers>
                <Content-type>{"application/x-www-form-urlencoded"}</Content-type>
                <Accept>{"text/csv"}</Accept>
            </headers>
            <data>{'query='||$PAYLOAD}</data>
            <authentication method="digest">
                <username>{$USERNAME}</username>
                <password>{$PASSWORD}</password>
            </authentication>
        </options>)[2]
return

if ($FORMAT eq "csv")
then (
    xdmp:set-response-content-type("application/csv"),
    xdmp:add-response-header("Content-Disposition", "attachment; filename=sparql-query.csv"),
    $POST
)
else (
    xdmp:set-response-content-type("application/zip"),
    xdmp:add-response-header("Content-Disposition", "attachment; filename=sparql-query.zip"),
    xdmp:zip-create(
            <parts xmlns="xdmp:zip">
                <part>sparql-query.csv</part>
            </parts>,
            ($POST)
    )
)